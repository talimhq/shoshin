require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:teaching_id).of_type(:integer) }
    it { is_expected.to have_db_index(:teaching_id) }
    it { is_expected.to have_db_column(:level_id).of_type(:integer) }
    it { is_expected.to have_db_index(:level_id) }
    it { is_expected.to have_db_column(:teacher_id).of_type(:integer) }
    it { is_expected.to have_db_index(:teacher_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:teaching) }
    it { is_expected.to belong_to(:level) }
    it { is_expected.to belong_to(:teacher) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:teaching) }
    it { is_expected.to validate_presence_of(:level) }
    it { is_expected.to validate_presence_of(:teacher) }
  end

  describe 'factories' do
    it { expect(build(:group)).to be_valid }
  end

  describe 'instance methods' do
    let(:group) { create(:group) }

    context 'teaching_name' do
      it 'returns the teaching name' do
        expect(group.teaching_name).to eq(group.teaching.name)
      end
    end

    context 'level_name' do
      it 'returns the level name' do
        expect(group.level_name).to eq(group.level.name)
      end
    end

    context 'display_name' do
      it 'composes teaching_name and level_name if no name' do
        expect(group.display_name).to \
          eq("#{group.teaching_name} (#{group.level_name})")
      end

      it 'returns name if present' do
        group.update(name: 'foo')
        expect(group.display_name).to eq('foo')
      end
    end
  end
end
