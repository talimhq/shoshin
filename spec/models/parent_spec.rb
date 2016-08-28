require 'rails_helper'

RSpec.describe Parent, type: :model do
  it_behaves_like User do
    let(:user) { create(:parent) }
  end

  describe 'db structure' do
  end

  describe 'associations' do
  end

  describe 'validations' do
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
    it { expect(build(:parent)).to be_valid }
  end
end
