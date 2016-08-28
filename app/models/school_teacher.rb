class SchoolTeacher < ApplicationRecord
  belongs_to :school, inverse_of: :school_teachers
  belongs_to :teacher, inverse_of: :school_teacher

  validates :school, :teacher, presence: true
  validates :approved, exclusion: { in: [nil] }
end
