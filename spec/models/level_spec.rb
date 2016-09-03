require 'rails_helper'

RSpec.describe Level, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:level_type).of_type(:string) }
    it { is_expected.to have_db_column(:cycle_id).of_type(:integer) }
    it { is_expected.to have_db_column(:position).of_type(:integer) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

    it { is_expected.to have_db_index(:cycle_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:cycle) }
    it { is_expected.to have_many(:theme_levels) }
    it { is_expected.to have_many(:classrooms) }
    it { is_expected.to have_many(:groups) }
    it { is_expected.to have_many(:editable_levels) }
    it { is_expected.to have_many(:exercises) }
    it { is_expected.to have_many(:lessons) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:short_name) }
    it { is_expected.to validate_presence_of(:cycle) }
    it { is_expected.to validate_presence_of(:level_type) }
    it { is_expected.to validate_inclusion_of(:level_type).in_array(Level.level_types) }
  end

  describe 'class methods' do
    context 'level_types' do
      it 'returns all possible level types' do
        expect(Level.level_types).to eq(%w(Primaire Collège Lycée))
      end
    end
  end

  describe 'instance methods' do
  end

  describe 'factories' do
    context 'standard one' do
      it { expect(build(:level)).to be_valid }
    end
  end
end
