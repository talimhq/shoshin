class ChapterExercise < ApplicationRecord
  belongs_to :chapter, inverse_of: :chapter_exercises,
                       counter_cache: :exercises_count
  belongs_to :exercise, inverse_of: :chapter_exercises

  validates :chapter, :exercise, presence: true
  validates_uniqueness_of :exercise, scope: :chapter
  validate :chapter_and_exercise_from_same_teacher

  private

  def chapter_and_exercise_from_same_teacher
    if chapter && exercise
      errors.add(:exercise_id, 'Cet exercice ne vous appartient pas') unless \
        chapter.teacher.in? exercise.authors
    end
  end
end
