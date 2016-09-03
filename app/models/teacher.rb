class Teacher < ApplicationRecord
  include User

  has_one :school_teacher, inverse_of: :teacher, dependent: :destroy
  accepts_nested_attributes_for :school_teacher
  has_one :school, through: :school_teacher

  has_many :authorships, inverse_of: :author, foreign_key: :teacher_id,
                         dependent: :destroy
  has_many :lessons, through: :authorships, source: :editable,
                     source_type: 'Lesson', inverse_of: :authors
  has_many :exercises, through: :authorships, source: :editable,
                       source_type: 'Exercise', inverse_of: :authors
  has_many :teacher_teaching_cycles, inverse_of: :teacher, dependent: :destroy
  has_many :user_exercise_forms, as: :user, dependent: :destroy
  has_many :groups, inverse_of: :teacher, dependent: :destroy

  validates :admin, :approved, exclusion: { in: [nil] }
  validates :account, presence: true

  def can_do?(exercise)
    exercise.shared || in?(exercise.authors)
  end

  def exercises_from_level(level)
    exercises.joins(:editable_levels).where(editable_levels: { level: level })
  end

  def lessons_from_level(level)
    lessons.joins(:editable_levels).where(editable_levels: { level: level })
  end
end
