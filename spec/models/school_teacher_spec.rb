require 'rails_helper'

RSpec.describe SchoolTeacher, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:school_id).of_type(:integer) }
    it { is_expected.to have_db_index(:school_id) }
    it { is_expected.to have_db_column(:teacher_id).of_type(:integer) }
    it { is_expected.to have_db_index(:teacher_id).unique }
    it { is_expected.to have_db_column(:approved).of_type(:boolean) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:school) }
    it { is_expected.to belong_to(:teacher) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:school) }
    it { is_expected.to validate_presence_of(:teacher) }
  end

  describe 'factories' do
    it { expect(build(:school_teacher)).to be_valid }
    it { expect(build(:unapproved_school_teacher)).to be_valid }
  end
end
