class ChapterLesson < ApplicationRecord
  belongs_to :chapter, inverse_of: :chapter_lessons, counter_cache: :lessons_count
  belongs_to :lesson, inverse_of: :chapter_lessons

  validates :chapter, :lesson, presence: true
  validates_uniqueness_of :chapter, scope: :lesson
  validate :chapter_and_lesson_from_same_teacher

  private

  def chapter_and_lesson_from_same_teacher
    if chapter && lesson
      errors.add(:lesson_id,
                 'Ce cours ne vous appartient pas') unless \
        chapter.teacher.in? lesson.authors
    end
  end
end
