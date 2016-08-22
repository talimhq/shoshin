require 'rails_helper'

RSpec.describe Classroom, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:school_id).of_type(:integer) }
    it { is_expected.to have_db_column(:level_id).of_type(:integer) }
    it { is_expected.to have_db_index(:school_id) }
    it { is_expected.to have_db_index(:level_id) }
    it { is_expected.to have_db_index([:school_id, :name]).unique }
    it { is_expected.to have_db_column(:students_count).of_type(:integer) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:school) }
    it { is_expected.to belong_to(:level) }
    it { is_expected.to have_many(:students) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:school) }
    it { is_expected.to validate_presence_of(:level) }

    it 'validates uniqueness of classroom name inside a school' do
      classroom = create(:classroom)
      duplicate_classroom = build(:classroom, name: classroom.name,
                                              school: classroom.school)
      expect(duplicate_classroom).not_to be_valid
    end
  end

  describe 'factories' do
    it 'has a valid factory' do
      expect(build(:classroom)).to be_valid
    end
  end

  describe 'instance methods' do
    let(:classroom) { create(:classroom) }

    context 'level_name' do
      it 'returns the level name' do
        expect(classroom.level_name).to eq(classroom.level.name)
      end
    end
  end
end
