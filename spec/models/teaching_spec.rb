require 'rails_helper'

RSpec.describe Teaching, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:short_name).of_type(:string) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:lessons) }
    it { is_expected.to have_many(:exercises) }
    it { is_expected.to have_many(:ability_sets) }
    it { is_expected.to have_many(:themes) }
    it { is_expected.to have_many(:teaching_cycles) }
    it { is_expected.to have_many(:cycles) }
    it { is_expected.to have_many(:groups) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:short_name) }
  end

  context 'factories' do
    describe 'standard one' do
      it { expect(build(:teaching)).to be_valid }
    end
  end
end
