class Questions::MultipleChoice < Question
  has_many :answers, class_name: 'Answers::MultipleChoice', inverse_of: :question, dependent: :destroy, foreign_key: :question_id
  accepts_nested_attributes_for :answers, allow_destroy: true
  validate :one_correct_answer?

  def correct_answers
    answers.where(correct: true)
  end

  def validate_answer(answer)
    !answer.blank? && (answer.sort == correct_answers.map(&:content).sort)
  end

  private

  def one_correct_answer?
    errors.add(:answers, 'Il doit y avoir au moins une bonne réponse.') unless !answers.any? || answers.map(&:correct).reduce(&:|)
  end
end
