require 'rails_helper'

RSpec.describe TeachingCycle, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:cycle_id).of_type(:integer) }
    it { is_expected.to have_db_column(:teaching_id).of_type(:integer) }

    it { is_expected.to have_db_index(:cycle_id) }
    it { is_expected.to have_db_index(:teaching_id) }
    it { is_expected.to have_db_index([:teaching_id, :cycle_id]).unique }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:cycle) }
    it { is_expected.to belong_to(:teaching) }
    it { is_expected.to have_many(:ability_sets) }
    it { is_expected.to have_many(:themes) }
    it { is_expected.to have_many(:teacher_teaching_cycles) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:cycle) }
    it { is_expected.to validate_presence_of(:teaching) }
    it 'validates uniqueness of [teaching, cycle]' do
      teaching_cycle = create(:teaching_cycle)
      expect(build(:teaching_cycle, teaching: teaching_cycle.teaching, cycle: teaching_cycle.cycle)).not_to be_valid
    end
  end

  describe 'instance methods' do
    let(:teaching_cycle) { create(:teaching_cycle) }

    it { expect(teaching_cycle.cycle_name).to eq(teaching_cycle.cycle.name) }
    it { expect(teaching_cycle.teaching_name).to eq(teaching_cycle.teaching.name) }
  end

  describe 'factories' do
    it { expect(create(:teaching_cycle)).to be_valid }
  end
end
