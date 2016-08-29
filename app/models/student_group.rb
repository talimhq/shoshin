class StudentGroup < ApplicationRecord
  belongs_to :student, inverse_of: :student_groups
  belongs_to :group, inverse_of: :student_groups

  validates :student, :group, presence: true
  validates_uniqueness_of :student, scope: :group
end
