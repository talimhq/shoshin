require 'rails_helper'

RSpec.describe Answers::FileUpload, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:file_format).of_type(:string) }
    it { is_expected.to have_db_column(:question_id).of_type(:integer) }
    it { is_expected.to have_db_index(:question_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:question) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:file_format) }
    it { is_expected.to validate_presence_of(:question) }
  end

  describe 'factories' do
    it { expect(create(:answers_file_upload)).to be_valid }
  end
end
