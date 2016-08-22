require 'rails_helper'

RSpec.describe AbilitySet, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:position).of_type(:integer) }
    it { is_expected.to have_db_column(:teaching_cycle_id).of_type(:integer) }

    it { is_expected.to have_db_index(:teaching_cycle_id) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:teaching_cycle) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:teaching_cycle) }
    it { is_expected.to have_many(:ability_items) }
  end

  describe 'instance methods' do
    let(:ability_set) { create(:ability_set) }

    it { expect(ability_set.teaching_name).to eq(ability_set.teaching_cycle.teaching_name) }
    it { expect(ability_set.cycle_name).to eq(ability_set.teaching_cycle.cycle_name) }
  end

  describe 'factories' do
    it { expect(create(:ability_set)).to be_valid }
  end
end
