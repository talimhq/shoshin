class EditableLevel < ApplicationRecord
  belongs_to :editable, polymorphic: true
  belongs_to :level, inverse_of: :editable_levels

  validates :level, presence: true
end
