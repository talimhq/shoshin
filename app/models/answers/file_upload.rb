class Answers::FileUpload < ApplicationRecord
  belongs_to :question, class_name: 'Questions::FileUpload', inverse_of: :answers, foreign_key: :question_id

  validates :file_format, :question, presence: true

  delegate :exercise, to: :question, prefix: false
end
