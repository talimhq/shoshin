class ChapterLesson < ApplicationRecord
  belongs_to :chapter, inverse_of: :chapter_lessons, counter_cache: :lessons_count
  belongs_to :lesson, inverse_of: :chapter_lessons

  validates :chapter, :lesson, presence: true
  validate :uniqueness_of_lesson_in_chapter
  validate :chapter_and_lesson_from_same_teacher

  delegate :name, to: :lesson, prefix: false
  delegate :steps, to: :lesson, prefix: false
  delegate :group, to: :chapter, prefix: false

  private

  def chapter_and_lesson_from_same_teacher
    if chapter && lesson
      errors.add(:lesson_id,
                 'Ce cours ne vous appartient pas') unless \
        chapter.teacher.in? lesson.authors
    end
  end

  def uniqueness_of_lesson_in_chapter
    if chapter && lesson
      chapter_lesson = ChapterLesson.find_by(chapter: chapter, lesson: lesson)
      unless chapter_lesson.nil? || self == chapter_lesson
        errors.add(:lesson_id, 'Vous ne pouvez pas ajouter deux fois le même cours dans le même chapitre')
        errors.add(:chapter_id, 'Vous ne pouvez pas ajouter deux fois le même cours dans le même chapitre')
      end
    end
  end
end
