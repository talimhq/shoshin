require 'rails_helper'

RSpec.describe Parent, type: :model do
  describe 'db structure' do
  end

  describe 'associations' do
    it { is_expected.to have_one(:account) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:account) }
  end

  describe 'instance methods' do
    let(:parent) { create(:parent) }

    context 'admin?' do
      it 'returns false' do
        expect(parent.admin?).to be_falsy
      end
    end
  end

  describe 'factories' do
    it { expect(build(:parent)).to be_valid}
  end
end
