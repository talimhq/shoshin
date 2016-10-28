class Group < ApplicationRecord
  belongs_to :teaching, inverse_of: :groups
  belongs_to :level, inverse_of: :groups
  belongs_to :teacher, inverse_of: :groups
  has_many :student_groups, inverse_of: :group, dependent: :destroy
  has_many :students, -> { joins(:account).order('accounts.last_name') },
           through: :student_groups
  has_many :chapters, -> { order(:position) }, inverse_of: :group, dependent: :destroy
  has_many :group_notifications, inverse_of: :group, dependent: :destroy

  validates :teaching, :level, :teacher, presence: true

  delegate :name, to: :teaching, prefix: true
  delegate :name, to: :level, prefix: true

  def display_name
    if name.blank?
      "#{teaching_name} (#{level_name})"
    else
      "#{name} (#{level.short_name} - #{teaching.short_name})"
    end
  end
end
