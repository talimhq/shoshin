require 'rails_helper'

RSpec.describe Questions::Association, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:answers) }
  end

  describe 'instance methods' do
    let(:question) do
      create(:association_question).becomes(Questions::Association)
    end

    it { expect(question.async?).to be_falsey }
    it { expect(question.print_type).to eq('association') }

    context 'validate_answer' do
      let(:answer1) { create(:answers_association, question: question) }
      let(:answer2) { create(:answers_association, question: question) }
      let(:answer3) { create(:answers_association, question: question) }

      it 'returns true if all the correct association are made' do
        answer = {
          answer1.id.to_s => answer1.right,
          answer2.id.to_s => answer2.right,
          answer3.id.to_s => answer3.right
        }
        expect(question.validate_answer(answer)).to be_truthy
      end

      it 'returns false if some wrong association are made' do
        answer = {
          answer1.id.to_s => answer2.right,
          answer2.id.to_s => answer1.right,
          answer3.id.to_s => answer3.right
        }
        expect(question.validate_answer(answer)).to be_falsey
      end

      it 'returns false if there are missing associations' do
        answer = {
          answer1.id.to_s => '',
          answer2.id.to_s => answer2.right,
          answer3.id.to_s => answer3.right
        }
        expect(question.validate_answer(answer)).to be_falsey
      end

      it 'returns false if no answers are provided' do
        expect(question.validate_answer(nil)).to be_falsey
      end
    end
  end

  describe 'factories' do
    it { expect(create(:association_question)).to be_valid }
  end
end
