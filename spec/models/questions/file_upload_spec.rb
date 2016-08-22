require 'rails_helper'

RSpec.describe Questions::FileUpload, type: :model do
  describe 'instance methods' do
    let(:question) { build(:file_upload_question) }
    it { expect(question.async?).to be_truthy }
    it { expect(question.print_type).to eq('file_upload') }
  end

  describe 'factories' do
    it { expect(create(:file_upload_question)).to be_valid }
  end
end
