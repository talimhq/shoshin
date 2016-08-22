require 'rails_helper'

RSpec.describe School, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:identifier).of_type(:string) }
    it { is_expected.to have_db_column(:city).of_type(:string) }
    it { is_expected.to have_db_column(:state).of_type(:string) }
    it { is_expected.to have_db_column(:country).of_type(:string) }
    it { is_expected.to have_db_column(:website).of_type(:string) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:teachers_count).of_type(:integer) }

    it { is_expected.to have_db_index(:identifier).unique }
    it { is_expected.to have_db_index([:country]) }
    it { is_expected.to have_db_index([:state, :country]) }
    it { is_expected.to have_db_index([:city, :state, :country]) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:teachers) }
    it { is_expected.to have_many(:pending_teachers) }
    it { is_expected.to have_many(:classrooms) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:identifier) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to validate_presence_of(:country) }

    it 'validates uniqueness of identifier' do
      school = create(:school)
      expect(build(:school, identifier: school.identifier)).not_to be_valid
    end
  end

  describe 'factories' do
    it { expect(build(:school)).to be_valid }
  end

  describe 'class methods' do
    it 'returns available states as an Array' do
      expect(School.states).to be_a Array
    end

    it 'returns Val-de-Marne as the 95th state name' do
      expect(School.states[94].first).to eq('Val-de-Marne')
    end

    it 'returns 94 as the 95th state code' do
      expect(School.states[94].last).to eq('94')
    end

    it 'returns Étranger as the last state name' do
      expect(School.states.last.first).to eq('Étranger')
    end

    it 'returns 99 as the last state code' do
      expect(School.states.last.last).to eq('99')
    end
  end

  describe 'instance methods' do
    let(:school) { create(:school) }

    it 'returns the country name in french' do
      school.update(country: 'BR')
      expect(school.country_name).to eq('Brésil')
    end

    it 'returns the state_name' do
      school.update(country: 'FR', state: '94')
      expect(school.state_name).to eq('Val-de-Marne')
    end

    it 'returns Étranger as state_name if country is not france' do
      school.update(country: 'BR')
      expect(school.state_name).to eq('Étranger')
    end
  end
end
