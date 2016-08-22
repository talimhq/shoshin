class AbilityItem < ApplicationRecord
  belongs_to :ability_set, inverse_of: :ability_items, counter_cache: true

  acts_as_list scope: :ability_set

  validates :name, :ability_set, presence: true
end
