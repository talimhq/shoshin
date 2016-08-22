class Cycle < ApplicationRecord
  scope :ordered, -> { order(:position) }

  has_many :levels, -> { order(position: :asc) }, inverse_of: :cycle,
                                                  dependent: :destroy
  accepts_nested_attributes_for :levels, allow_destroy: :true
  has_many :teaching_cycles, inverse_of: :cycle, dependent: :destroy

  acts_as_list

  validates :name, presence: true
end
