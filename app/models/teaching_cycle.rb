class TeachingCycle < ApplicationRecord
  scope :ordered, -> { includes(:teaching, :cycle).order('cycles.name', 'teachings.name') }

  belongs_to :teaching, inverse_of: :teaching_cycles
  belongs_to :cycle, inverse_of: :teaching_cycles
  has_many :ability_sets, inverse_of: :teaching_cycle, dependent: :destroy
  has_many :themes, inverse_of: :teaching_cycle, dependent: :destroy

  validates :teaching, :cycle, presence: true
  validates_uniqueness_of :cycle, scope: :teaching

  delegate :name, to: :cycle, prefix: true
  delegate :name, to: :teaching, prefix: true
end
