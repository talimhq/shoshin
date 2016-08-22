class Questions::Input < Question
  has_many :answers, class_name: 'Answers::Input', inverse_of: :question, dependent: :destroy, foreign_key: :question_id
  accepts_nested_attributes_for :answers, allow_destroy: true

  def validate_answer(answer)
    answer.in? answers.map(&:content)
  end
end
