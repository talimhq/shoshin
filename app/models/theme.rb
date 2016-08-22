class Theme < ApplicationRecord
  belongs_to :teaching_cycle, inverse_of: :themes
  has_one :cycle, through: :teaching_cycle
  has_many :theme_levels, inverse_of: :theme, dependent: :destroy
  accepts_nested_attributes_for :theme_levels, allow_destroy: true
  has_many :levels, through: :theme_levels, source: :level
  has_many :expectations, inverse_of: :theme, dependent: :destroy

  validates :teaching_cycle, :name, presence: true
  validate :has_at_least_one_theme_level

  delegate :teaching_name, to: :teaching_cycle, prefix: false
  delegate :cycle_name, to: :teaching_cycle, prefix: false

  acts_as_list scope: :teaching_cycle

  def level_names
    levels.map(&:name).join(', ')
  end

  private

  def has_at_least_one_theme_level
    errors.add(:theme_levels, 'Doit avoir au moins un niveau.') if theme_levels.empty? || theme_levels.all?(&:marked_for_destruction?)
  end
end
