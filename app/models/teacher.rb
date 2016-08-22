class Teacher < ApplicationRecord
  belongs_to :school, counter_cache: true

  has_one :account, as: :user, dependent: :destroy
  accepts_nested_attributes_for :account

  has_many :authorships, inverse_of: :author, foreign_key: :teacher_id,
                         dependent: :destroy
  has_many :lessons, through: :authorships, source: :editable,
                     source_type: 'Lesson', inverse_of: :authors
  has_many :exercises, through: :authorships, source: :editable,
                       source_type: 'Exercise', inverse_of: :authors
  has_many :teacher_teaching_cycles, inverse_of: :teacher, dependent: :destroy
  has_many :teacher_exercise_forms, inverse_of: :teacher, dependent: :destroy
  has_many :groups, inverse_of: :teacher, dependent: :destroy

  validates :admin, :approved, exclusion: { in: [nil] }
  validates :account, presence: true
end
