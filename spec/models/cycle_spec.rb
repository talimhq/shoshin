require 'rails_helper'

RSpec.describe Cycle, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:position).of_type(:integer) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:levels) }
    it { is_expected.to have_many(:teaching_cycles) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'scopes' do
    context 'ordered' do
      it 'orders cycles by position' do
        cycle1 = create(:cycle, position: 1)
        cycle2 = create(:cycle, position: 2)
        expect(Cycle.ordered).to eq([cycle1, cycle2])
      end
    end
  end

  describe 'factories' do
    context 'standard one' do
      it { expect(build(:cycle)).to be_valid }
    end
  end
end
