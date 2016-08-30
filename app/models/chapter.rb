class Chapter < ApplicationRecord
  belongs_to :group, inverse_of: :chapters
  has_many :chapter_lessons, inverse_of: :chapter, dependent: :destroy
  has_many :lessons, through: :chapter_lessons
  has_many :chapter_exercises, inverse_of: :chapter, dependent: :destroy
  has_many :exercises, through: :chapter_exercises
  has_one :teacher, through: :group

  validates :group, :name, presence: true
  acts_as_list scope: :group

  delegate :level, to: :group, prefix: false
end
