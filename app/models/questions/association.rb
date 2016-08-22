class Questions::Association < Question
  has_many :answers, class_name: 'Answers::Association', inverse_of: :question, dependent: :destroy, foreign_key: :question_id
  accepts_nested_attributes_for :answers, allow_destroy: true

  def validate_answer(answer)
    answers.map { |correct_answer|
      answer[correct_answer.id.to_s] == correct_answer.right
    }.reduce(&:&)
  end
end
