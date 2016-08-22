class Answers::Association < ApplicationRecord
  belongs_to :question, class_name: 'Questions::Association', inverse_of: :answers, foreign_key: :question_id

  validates :left, :right, :question, presence: true

  delegate :exercise, to: :question, prefix: false
end
