class UserExerciseForm < ApplicationRecord
  belongs_to :user, polymorphic: true
  belongs_to :exercise, inverse_of: :user_exercise_forms

  store_accessor :answers
  store_accessor :results

  validates :user, :exercise, presence: true
  validates :user_type, inclusion: { in: %w(Student Teacher) }

  delegate :name, to: :exercise, prefix: true
  delegate :statement, to: :exercise, prefix: true
  delegate :questions, to: :exercise, prefix: false

  def auto_correct
    answers.each do |question_id, answer|
      question = Question.find(question_id)
      results[question_id.to_s] = question.validate_answer(answer) if question.respond_to?(:validate_answer)
    end
  end

  def score
    "#{points}/#{total}"
  end

  def points
    results.map { |_k, v| v ? 1 : 0 }.reduce(&:+)
  end

  def total
    results.length
  end
end
