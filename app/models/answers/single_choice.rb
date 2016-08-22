class Answers::SingleChoice < ApplicationRecord
  belongs_to :question, class_name: 'Questions::SingleChoice', inverse_of: :answers, foreign_key: :question_id

  validates :question, :content, presence: true
  validates :correct, exclusion: { in: [nil] }

  delegate :exercise, to: :question, prefix: false
end
