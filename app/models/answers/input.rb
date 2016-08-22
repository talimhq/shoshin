class Answers::Input < ApplicationRecord
  belongs_to :question, class_name: 'Questions::Input', inverse_of: :answers, foreign_key: :question_id

  validates :question, :content, presence: true

  delegate :exercise, to: :question, prefix: false
end
