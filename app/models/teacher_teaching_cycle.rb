class TeacherTeachingCycle < ApplicationRecord
  belongs_to :teacher, inverse_of: :teacher_teaching_cycles
  belongs_to :teaching_cycle, inverse_of: :teacher_teaching_cycles

  validates :teacher, :teaching_cycle, presence: true
  validates_uniqueness_of :teacher, scope: :teaching_cycle

  delegate :teaching_name, to: :teaching_cycle, prefix: false
  delegate :cycle_name, to: :teaching_cycle, prefix: false
end
