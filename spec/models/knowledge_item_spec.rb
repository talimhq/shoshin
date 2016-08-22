require 'rails_helper'

RSpec.describe KnowledgeItem, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:expectation_id).of_type(:integer) }

    it { is_expected.to have_db_index(:expectation_id) }
  end
 
  describe 'associations' do
    it { is_expected.to belong_to(:expectation) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:expectation) }
  end

  describe 'factories' do
    it { expect(build(:knowledge_item)).to be_valid }
  end
end
