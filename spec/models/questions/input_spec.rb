require 'rails_helper'

RSpec.describe Questions::Input, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:answers) }
  end

  describe 'instance methods' do
    let(:question) { build(:input_question) }
    it { expect(question.async?).to be_falsey }
    it { expect(question.print_type).to eq('input') }
  end

  describe 'factories' do
    it { expect(create(:input_question)).to be_valid }
  end
end
