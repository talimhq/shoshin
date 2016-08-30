require 'rails_helper'

RSpec.describe Chapter, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:group_id).of_type(:integer) }
    it { is_expected.to have_db_index(:group_id) }
    it { is_expected.to have_db_column(:position).of_type(:integer) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:group) }
    it { is_expected.to have_many(:chapter_lessons) }
    it { is_expected.to have_many(:lessons) }
    it { is_expected.to have_one(:teacher) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:group) }
  end

  describe 'factories' do
    it { expect(build(:chapter)).to be_valid }
  end
end
