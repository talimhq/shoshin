require 'rails_helper'

RSpec.describe EditableLevel, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:level_id).of_type(:integer) }
    it { is_expected.to have_db_index(:level_id) }
    it { is_expected.to have_db_column(:editable_type).of_type(:string) }
    it { is_expected.to have_db_column(:editable_id).of_type(:integer) }
    it { is_expected.to have_db_index([:editable_type, :editable_id]) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:editable) }
    it { is_expected.to belong_to(:level) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:level) }
  end

  describe 'factories' do
    it { expect(build(:editable_level)).to be_valid }
    it { expect(build(:exercise_level)).to be_valid }
    it { expect(build(:lesson_level)).to be_valid }
  end
end
