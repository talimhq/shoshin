require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:first_name).of_type(:string) }
    it { is_expected.to have_db_column(:last_name).of_type(:string) }
    it { is_expected.to have_db_column(:user_type).of_type(:string) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:encrypted_password).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_token).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:remember_created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:sign_in_count).of_type(:integer) }
    it { is_expected.to have_db_column(:current_sign_in_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:last_sign_in_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:current_sign_in_ip).of_type(:inet) }
    it { is_expected.to have_db_column(:last_sign_in_ip).of_type(:inet) }
    it { is_expected.to have_db_column(:confirmation_token).of_type(:string) }
    it { is_expected.to have_db_column(:confirmed_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:confirmation_sent_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:unconfirmed_email).of_type(:string) }
    it { is_expected.to have_db_column(:failed_attempts).of_type(:integer) }
    it { is_expected.to have_db_column(:unlock_token).of_type(:string) }
    it { is_expected.to have_db_column(:locked_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

    it { is_expected.to have_db_index([:user_type, :user_id]).unique }
    it { is_expected.to have_db_index(:email).unique }
    it { is_expected.to have_db_index(:confirmation_token).unique }
    it { is_expected.to have_db_index(:reset_password_token).unique }
    it { is_expected.to have_db_index(:unlock_token).unique }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_inclusion_of(:user_type).in_array(Account.user_types) }
  end

  describe 'class methods' do
    context 'user_types' do
      it 'returns a list of possible user_types' do
        expect(Account.user_types).to eq(%w(Student Parent Teacher))
      end
    end
  end

  describe 'instance methods' do
    context 'role' do
      it 'returns student for Student' do
        account = create(:student).account
        expect(account.role).to eq('student')
      end

      # it 'returns parent for parent' do
      #   account.update(user_type: 'Parent')
      #   expect(account.role).to eq('parent')
      # end

      it 'returns teacher for Teacher' do
        account = create(:teacher).account
        expect(account.role).to eq('teacher')
      end
    end
  end

  describe 'factories' do
    it { expect(build(:account)).to be_valid }
  end
end
