class AbilitySet < ApplicationRecord
  scope :ordered, -> { order(position: :asc) }

  has_many :ability_items, -> { order(position: :asc) }, inverse_of: :ability_set, dependent: :destroy
  accepts_nested_attributes_for :ability_items, allow_destroy: true
  belongs_to :teaching_cycle, inverse_of: :ability_sets

  acts_as_list scope: :teaching_cycle

  validates :name, :teaching_cycle, presence: true

  delegate :teaching_name, to: :teaching_cycle, prefix: false
  delegate :cycle_name, to: :teaching_cycle, prefix: false
end
