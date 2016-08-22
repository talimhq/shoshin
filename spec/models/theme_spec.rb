require 'rails_helper'

RSpec.describe Theme, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:position).of_type(:integer) }
    it { is_expected.to have_db_column(:teaching_cycle_id).of_type(:integer) }
    it { is_expected.to have_db_column(:expectations_count).of_type(:integer) }

    it { is_expected.to have_db_index(:teaching_cycle_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:teaching_cycle) }
    it { is_expected.to have_many(:theme_levels) }
    it { is_expected.to have_many(:levels) }
    it { is_expected.to have_many(:expectations) }
    it { is_expected.to have_one(:cycle) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:teaching_cycle) }
    it 'expects at least one theme_level' do
      theme = build(:theme)
      theme.theme_levels.destroy_all
      expect(theme).not_to be_valid
    end
  end

  describe 'instance methods' do
    let(:theme) { create(:theme) }

    it { expect(theme.teaching_name).to eq(theme.teaching_cycle.teaching_name) }
    it { expect(theme.cycle_name).to eq(theme.teaching_cycle.cycle_name) }
    it { expect(theme.level_names).to eq(theme.levels.first.name) }
  end

  describe 'factories' do
    it { expect(create(:theme)).to be_valid }
  end
end
