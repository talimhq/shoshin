require 'rails_helper'

RSpec.describe Student, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:classroom_id).of_type(:integer) }
    it { is_expected.to have_db_index(:classroom_id) }
  end

  describe 'association' do
    it { is_expected.to have_one(:account) }
    it { is_expected.to belong_to(:classroom) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:classroom) }
    it { is_expected.to validate_presence_of(:account) }
  end

  describe 'factories' do
    it { expect(build(:student)).to be_valid }
  end
end
