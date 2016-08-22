require 'rails_helper'

RSpec.describe Teacher, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:school_id).of_type(:integer) }
    it { is_expected.to have_db_column(:approved).of_type(:boolean) }
    it { is_expected.to have_db_column(:admin).of_type(:boolean) }
    it { is_expected.to have_db_column(:old_id).of_type(:integer) }
    it { is_expected.to have_db_index(:school_id) }
    it { is_expected.to have_db_index(:old_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:school) }
    it { is_expected.to have_many(:authorships) }
    it { is_expected.to have_many(:lessons) }
    it { is_expected.to have_many(:exercises) }
    it { is_expected.to have_many(:teacher_teaching_cycles) }
    it { is_expected.to have_many(:teacher_exercise_forms) }
    it { is_expected.to have_many(:groups) }
  end

  describe 'validations' do
    it { is_expected.to validate_exclusion_of(:approved).in_array([nil]) }
    it { is_expected.to validate_exclusion_of(:admin).in_array([nil]) }
    it { is_expected.to validate_presence_of(:account) }
  end

  describe 'factories' do
    it { expect(build(:teacher)).to be_valid }
  end
end
