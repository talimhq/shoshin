require 'rails_helper'

RSpec.describe TeacherTeachingCycle, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:teacher_id).of_type(:integer) }
    it { is_expected.to have_db_column(:teaching_cycle_id).of_type(:integer) }

    it { is_expected.to have_db_index(:teacher_id) }
    it { is_expected.to have_db_index(:teaching_cycle_id) }
    it { is_expected.to have_db_index([:teacher_id, :teaching_cycle_id]).unique }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:teacher) }
    it { is_expected.to belong_to(:teaching_cycle) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:teacher) }
    it { is_expected.to validate_presence_of(:teaching_cycle) }

    it 'validates uniqueness of teaching_cycle for a teacher' do
      teacher_teaching_cycle = create(:teacher_teaching_cycle)
      expect(
        build(
          :teacher_teaching_cycle,
          teacher: teacher_teaching_cycle.teacher,
          teaching_cycle: teacher_teaching_cycle.teaching_cycle
        )
      ).not_to be_valid
    end
  end

  describe 'factories' do
    it { expect(create(:teacher_teaching_cycle)).to be_valid }
  end

  describe 'instance method' do
    let(:teacher_teaching_cycle) { create(:teacher_teaching_cycle) }

    it 'delegates teaching_name to teaching_cycle' do
      expect(teacher_teaching_cycle.teaching_name).to \
        eq(teacher_teaching_cycle.teaching_cycle.teaching_name)
    end

    it 'delegates cycle_name to teaching cycle' do
      expect(teacher_teaching_cycle.cycle_name).to \
        eq(teacher_teaching_cycle.teaching_cycle.cycle_name)
    end
  end
end
