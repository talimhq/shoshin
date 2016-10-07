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
  has_many :user_exercise_forms, as: :user, dependent: :destroy
  has_many :groups, inverse_of: :teacher, dependent: :destroy
  has_many :group_notifications, as: :user, dependent: :destroy

  validates :admin, :approved, exclusion: { in: [nil] }
  validates :account, presence: true

  def exercises_from_level(level)
    editables_by_level(:exercises, level)
  end

  def lessons_from_level(level)
    editables_by_level(:lessons, level)
  end

  private

  def editables_by_level(editable, level)
    send(editable).joins(:editable_levels)
                  .where(editable_levels: { level: level })
  end
end
