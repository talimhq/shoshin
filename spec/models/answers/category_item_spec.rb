require 'rails_helper'

RSpec.describe Answers::CategoryItem, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:content).of_type(:string) }
    it { is_expected.to have_db_column(:answers_category_id).of_type(:integer) }

    it { is_expected.to have_db_index(:answers_category_id) }
  end

  describe 'assoctions' do
    it { is_expected.to belong_to(:category) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:category) }
  end

  describe 'factories' do
    it { expect(create(:answers_category_item)).to be_valid }
  end
end
