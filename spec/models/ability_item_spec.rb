require 'rails_helper'

RSpec.describe AbilityItem, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:position).of_type(:integer) }
    it { is_expected.to have_db_column(:ability_set_id).of_type(:integer) }

    it { is_expected.to have_db_index(:ability_set_id) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:ability_set) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:ability_set) }
  end

  describe 'factories' do
    it { expect(create(:ability_item)).to be_valid }
  end
end
