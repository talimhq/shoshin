require 'rails_helper'

RSpec.describe Questions::MultipleChoice, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:answers) }
  end

  describe 'validations' do
    let(:question) { create(:multiple_choice_question).becomes(Questions::MultipleChoice) }

    it 'no correct answers' do
      create(:answers_multiple_choice, correct: false, question: question)
      expect(question).not_to be_valid
    end

    it 'multiple correct answers' do
      create(:answers_multiple_choice, correct: true, question: question)
      create(:answers_multiple_choice, correct: true, question: question)
      expect(question).to be_valid
    end

    it 'unique correct answer' do
      create(:answers_multiple_choice, correct: true, question: question)
      expect(question).to be_valid
    end
  end

  describe 'instance methods' do
    let(:question) do
      create(:multiple_choice_question).becomes(Questions::MultipleChoice)
    end

    it { expect(question.async?).to be_falsey }
    it { expect(question.print_type).to eq('multiple_choice') }

    it 'returns the correct answers' do
      right_answer = create(:answers_multiple_choice, question: question,
                                                      correct: true)
      create(:answers_multiple_choice, question: question, correct: false)
      expect(question.correct_answers).to eq([right_answer])
    end

    context 'validate_answer' do
      it 'returns true if every correct answers are provided' do
        right_answer1 = create(:answers_multiple_choice, question: question,
                                                         correct: true)
        right_answer2 = create(:answers_multiple_choice, question: question,
                                                         correct: true)
        expect(
          question.validate_answer(
            [right_answer2.content, right_answer1.content]
          )
        ).to be_truthy
      end

      it 'returns false if not all correct answers are provided' do
        right_answer1 = create(:answers_multiple_choice, question: question,
                                                         correct: true)
        create(:answers_multiple_choice, question: question, correct: true)
        expect(question.validate_answer([right_answer1.content])).to be_falsey
      end

      it 'returns false if only incorrect answers are provided' do
        create(:answers_multiple_choice, question: question, correct: true)
        wrong_answer = create(:answers_multiple_choice, question: question,
                                                        correct: false)
        expect(question.validate_answer([wrong_answer.content])).to be_falsey
      end

      it 'returns false if no answer are provided' do
        expect(question.validate_answer('')).to be_falsey
      end
    end
  end

  describe 'factories' do
    it { expect(create(:multiple_choice_question)).to be_valid }
  end
end
