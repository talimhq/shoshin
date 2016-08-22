class Questions::SingleChoice < Question
  has_many :answers, class_name: 'Answers::SingleChoice', inverse_of: :question, dependent: :destroy, foreign_key: :question_id
  accepts_nested_attributes_for :answers, allow_destroy: true
  validate :exactly_one_correct_answer?

  def correct_answers
    answers.where(correct: true)
  end

  def correct_answers_count
    correct_answers.size
  end

  def validate_answer(answer)
    answer == correct_answers.first.content
  end

  private

  def exactly_one_correct_answer?
    errors.add(:answers, 'Il doit y avoir exactement une bonne réponse.') unless !answers.any? || answers.map { |a| a.correct ? 1 : 0 }.reduce(&:+) == 1
  end
end
