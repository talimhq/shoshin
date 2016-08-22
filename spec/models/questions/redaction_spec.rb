require 'rails_helper'

RSpec.describe Questions::Redaction, type: :model do
  describe 'instance methods' do
    let(:question) { build(:redaction_question) }
    it { expect(question.async?).to be_truthy }
    it { expect(question.print_type).to eq('redaction') }
  end

  describe 'factories' do
    it { expect(create(:redaction_question)).to be_valid }
  end
end
