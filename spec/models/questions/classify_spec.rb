require 'rails_helper'

RSpec.describe Questions::Classify, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:answers) }
  end

  describe 'instance methods' do
    let(:question) { build(:classify_question).becomes(Questions::Classify) }

    it { expect(question.async?).to be_falsey }
    it { expect(question.print_type).to eq('classify') }

    context 'validate_answer' do
      let(:category1) { create(:answers_category, question: question) }
      let(:category2) { create(:answers_category, question: question) }
      let(:item1a) { create(:answers_category_item, category: category1) }
      let(:item1b) { create(:answers_category_item, category: category1) }
      let(:item2a) { create(:answers_category_item, category: category2) }
      let(:item2b) { create(:answers_category_item, category: category2) }

      it 'return true if the correct associations are made' do
        answer = {
          item1a.id.to_s => category1.name,
          item2a.id.to_s => category2.name,
          item1b.id.to_s => category1.name,
          item2b.id.to_s => category2.name
        }
        expect(question.validate_answer(answer)).to be_truthy
      end

      it 'return false if the associations are wrong' do
        answer = {
          item1a.id.to_s => category2.name,
          item2a.id.to_s => category2.name,
          item1b.id.to_s => category1.name,
          item2b.id.to_s => category2.name
        }
        expect(question.validate_answer(answer)).to be_falsey
      end

      it 'returns false if there are missing associations' do
        answer = {
          item1a.id.to_s => '',
          item2a.id.to_s => category2.name,
          item1b.id.to_s => category1.name,
          item2b.id.to_s => category2.name
        }
        expect(question.validate_answer(answer)).to be_falsey
      end

      it 'returns false if no answer is provided' do
        expect(question.validate_answer(nil)).to be_falsey
      end
    end
  end

  describe 'factories' do
    it { expect(create(:classify_question)).to be_valid }
  end
end
