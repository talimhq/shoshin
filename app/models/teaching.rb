class Teaching < ApplicationRecord
  scope :ordered, -> { order(name: :asc) }

  has_many :lessons, inverse_of: :teaching, dependent: :destroy
  has_many :exercises, inverse_of: :teaching, dependent: :destroy
  has_many :teaching_cycles, inverse_of: :teaching, dependent: :destroy
  has_many :cycles, -> { order(position: :asc) }, through: :teaching_cycles
  has_many :ability_sets, through: :teaching_cycles 
  has_many :themes, -> { order(position: :asc) }, through: :teaching_cycles
  has_many :groups, inverse_of: :teaching, dependent: :destroy

  validates :name, presence: true
  validates :short_name, presence: true
  validate :has_at_least_one_cycle

  private

  def has_at_least_one_cycle
    errors.add(:cycles, 'Doit avoir au moins un cycle.') if cycles.empty?
  end
end
