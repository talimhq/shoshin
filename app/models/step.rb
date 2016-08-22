class Step < ApplicationRecord
  belongs_to :lesson, inverse_of: :steps, counter_cache: true
  acts_as_list scope: :lesson

  validates :content, :lesson, presence: true

  delegate :authors, to: :lesson, prefix: false

  def print_title
    title ? title : "Séance #{position}"
  end

  def build_copy(new_lesson)
    new_lesson.steps.new(content: content, title: title, position: position)
  end
end
