require 'rails_helper'

RSpec.describe GroupNotification, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:group_id).of_type(:integer) }
    it { is_expected.to have_db_index(:group_id) }
    it { is_expected.to have_db_column(:user_type).of_type(:string) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_index([:user_type, :user_id]) }
    it { is_expected.to have_db_column(:body).of_type(:text) }
    it { is_expected.to have_db_column(:kind).of_type(:string) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:group) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:group) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:kind) }
    it { is_expected.to validate_inclusion_of(:user_type).in_array(%w(Student Teacher)) }
  end

  describe 'factories' do
    it { expect(create(:group_notification)).to be_valid }
  end
end
