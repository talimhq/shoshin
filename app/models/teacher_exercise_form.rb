class TeacherExerciseForm < ApplicationRecord
  belongs_to :teacher, inverse_of: :teacher_exercise_forms
  belongs_to :exercise, inverse_of: :teacher_exercise_forms

  store_accessor :answers
  store_accessor :results

  validates :teacher, :exercise, presence: true

  delegate :name, to: :exercise, prefix: true
  delegate :statement, to: :exercise, prefix: true
  delegate :questions, to: :exercise, prefix: false

  def auto_correct
    answers.each do |question_id, answer|
      question = Question.find(question_id)
      results[question_id.to_s] = question.validate_answer(answer) if question.respond_to?(:validate_answer)
    end
  end
end
