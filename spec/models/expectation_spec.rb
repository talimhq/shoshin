require 'rails_helper'

RSpec.describe Expectation, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:theme_id).of_type(:integer) }
    it { is_expected.to have_db_column(:knowledge_items_count).of_type(:integer) }

    it { is_expected.to have_db_index(:theme_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:theme) }
    it { is_expected.to have_many(:knowledge_items) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:theme) }
  end

  describe 'factories' do
    it { expect(create(:expectation)).to be_valid }
  end
end
