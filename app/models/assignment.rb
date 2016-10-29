class Assignment < ApplicationRecord
  belongs_to :chapter, inverse_of: :assignments,
                       counter_cache: :exercises_count
  belongs_to :exercise, inverse_of: :assignments
  has_many :student_exercise_forms, inverse_of: :assignment, dependent: :destroy

  validates :chapter, :exercise, presence: true
  validate :uniqueness_of_exercise_in_chapter
  validate :chapter_and_exercise_from_same_teacher

  delegate :name, to: :exercise, prefix: true
  delegate :questions, to: :exercise, prefix: false
  delegate :group, to: :chapter, prefix: false

  store_accessor :ability_evaluations
  store_accessor :expectation_evaluations

  def assessed?
    !ability_evaluations.empty? || !expectation_evaluations.empty?
  end

  private

  def chapter_and_exercise_from_same_teacher
    if chapter && exercise
      errors.add(:exercise_id, 'Cet exercice ne vous appartient pas') unless \
        chapter.teacher.in? exercise.authors
    end
  end

  def uniqueness_of_exercise_in_chapter
    if chapter && exercise
      assignment = Assignment.find_by(chapter: chapter, exercise: exercise)
      unless assignment.nil? || self == assignment
        errors.add(:exercise_id, 'Vous ne pouvez pas ajouter deux fois le même exercice dans le même chapitre')
        errors.add(:chapter_id, 'Vous ne pouvez pas ajouter deux fois le même exercice dans le même chapitre')
      end
    end
  end
end
