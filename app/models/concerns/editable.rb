module Editable
  def self.included(base)
    base.class_eval do
      has_many :authorships, as: :editable, dependent: :destroy
    end
  end

  def levels
    Level.find(level_ids)
  end

  def level_names
    levels.map(&:short_name).join(',')
  end
end
