require 'rails_helper'

RSpec.describe Questions::SingleChoice, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:answers) }
  end

  describe 'validations' do
    let(:question) { create(:single_choice_question).becomes(Questions::SingleChoice) }

    it 'no correct answers' do
      create(:answers_single_choice, correct: false, question: question)
      expect(question).not_to be_valid
    end

    it 'multiple correct answers' do
      create(:answers_single_choice, correct: true, question: question)
      create(:answers_single_choice, correct: true, question: question)
      expect(question).not_to be_valid
    end

    it 'unique correct answer' do
      create(:answers_single_choice, correct: true, question: question)
      expect(question).to be_valid
    end
  end

  describe 'instance methods' do
    let(:question) do
      create(:single_choice_question).becomes(Questions::SingleChoice)
    end

    it { expect(question.async?).to be_falsey }
    it { expect(question.print_type).to eq('single_choice') }

    it 'return the correct answers' do
      answer = create(:answers_single_choice, question: question, correct: true)
      expect(question.correct_answers).to eq([answer])
    end

    it 'returns the correct answers count' do
      create(:answers_single_choice, question: question, correct: true)
      expect(question.correct_answers_count).to eq(1)
    end

    context 'validate answer' do
      it 'returns true if the correct answer is given' do
        answer = create(:answers_single_choice, question: question,
                                                correct: true)
        expect(question.validate_answer(answer.content)).to be_truthy
      end

      it 'returns false if wrong  answer is given' do
        create(:answers_single_choice, question: question, correct: true)
        answer = create(:answers_single_choice, question: question,
                                                correct: false)
        expect(question.validate_answer(answer.content)).to be_falsey
      end

      it 'returns false if no answer is given' do
        create(:answers_single_choice, question: question, correct: true)
        expect(question.validate_answer(nil)).to be_falsey
      end
    end
  end

  describe 'factories' do
    it { expect(create(:single_choice_question)).to be_valid }
  end
end
