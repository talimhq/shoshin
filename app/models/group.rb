class Group < ApplicationRecord
  belongs_to :teaching, inverse_of: :groups
  belongs_to :level, inverse_of: :groups
  belongs_to :teacher, inverse_of: :groups

  validates :teaching, :level, :teacher, presence: true

  delegate :name, to: :teaching, prefix: true
  delegate :name, to: :level, prefix: true

  def name
    "#{teaching_name} (#{level_name})"
  end
end
