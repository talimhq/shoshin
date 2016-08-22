class Expectation < ApplicationRecord
  belongs_to :theme, inverse_of: :expectations, counter_cache: true
  has_many :knowledge_items, inverse_of: :expectation, dependent: :destroy
  accepts_nested_attributes_for :knowledge_items, allow_destroy: true

  validates :theme, :name, presence: true
end
