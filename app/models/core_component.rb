class CoreComponent < ApplicationRecord
  scope :ordered, -> { order(name: :asc) }

  validates :name, presence: true
end
