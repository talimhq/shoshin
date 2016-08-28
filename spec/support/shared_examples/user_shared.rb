RSpec.shared_examples User do
  describe 'associations' do
    it { is_expected.to have_one(:account) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:account) }
  end

  describe 'instance methods' do
    it 'delegates first_name to account' do
      expect(user.first_name).to eq(user.account.first_name)
    end

    it 'delegates last_name to account' do
      expect(user.last_name).to eq(user.account.last_name)
    end

    it 'delegates full_name to account' do
      expect(user.full_name).to eq(user.account.full_name)
    end

    it 'delegates email to account' do
      expect(user.email).to eq(user.account.email)
    end
  end
end
