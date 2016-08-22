class Classroom < ApplicationRecord
  belongs_to :level, inverse_of: :classrooms
  belongs_to :school, inverse_of: :classrooms
  has_many :students, inverse_of: :classroom, dependent: :restrict_with_error
  accepts_nested_attributes_for :students, allow_destroy: true

  validates :name, :level, :school, presence: true
  validates_uniqueness_of :name, scope: :school

  delegate :name, to: :level, prefix: true
end
