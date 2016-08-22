class Questions::FileUpload < Question
  has_many :answers, class_name: 'Answers::FileUpload', inverse_of: :question, dependent: :destroy, foreign_key: :question_id
  accepts_nested_attributes_for :answers, allow_destroy: true
end
