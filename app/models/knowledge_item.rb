class KnowledgeItem < ApplicationRecord
  belongs_to :expectation, inverse_of: :knowledge_items, counter_cache: true

  validates :name, :expectation, presence: true
end
