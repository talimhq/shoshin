require 'rails_helper'

RSpec.describe StudentGroup, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:student_id).of_type(:integer) }
    it { is_expected.to have_db_index(:student_id) }
    it { is_expected.to have_db_column(:group_id).of_type(:integer) }
    it { is_expected.to have_db_index(:group_id) }
    it { is_expected.to have_db_index([:group_id, :student_id]).unique }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:student) }
    it { is_expected.to belong_to(:group) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:student) }
    it { is_expected.to validate_presence_of(:group) }

    it 'validates uniqueness of student/group' do
      student_group = create(:student_group)
      duplicate = build(:student_group, student: student_group.student,
                                        group: student_group.group)
      expect(duplicate).not_to be_valid
    end
  end

  describe 'factories' do
    it { expect(build(:student_group)).to be_valid }
  end
end
