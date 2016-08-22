class ThemeLevel < ApplicationRecord
  belongs_to :theme, inverse_of: :theme_levels
  belongs_to :level, inverse_of: :theme_levels

  validates :theme, :level, :kind, presence: true
  validates :kind, inclusion: { in: %w(Obligatoire Spécialité Facultatif) }

  def self.kinds
    %w(Obligatoire Spécialité Facultatif)
  end
end
