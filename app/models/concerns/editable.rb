module Editable
  def self.included(base)
    base.class_eval do
      has_many :authorships, as: :editable, dependent: :destroy
      has_many :editable_levels, as: :editable, dependent: :destroy
      has_many :levels, through: :editable_levels, source: :level

      validates :levels, presence: true
    end
  end

  def level_names
    levels.map(&:short_name).join(', ')
  end
end
