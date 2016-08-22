require 'rails_helper'

RSpec.describe CoreComponent, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
  end

  describe 'associations' do
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'factories' do
    context 'standard one' do
      it { expect(build(:core_component)).to be_valid }
    end
  end
end
