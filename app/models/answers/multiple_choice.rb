class Answers::MultipleChoice < ApplicationRecord
  belongs_to :question, class_name: 'Questions::MultipleChoice', inverse_of: :answers, foreign_key: :question_id

  validates :question, :content, presence: true
  validates :correct, exclusion: { in: [nil] }

  delegate :exercise, to: :question, prefix: false
end
