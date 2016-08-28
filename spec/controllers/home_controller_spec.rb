require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  context 'as a guest' do
    describe 'GET #guest' do
      it { expect(get(:guest)).to have_http_status(200) }
    end

    describe 'GET #user' do
      it { expect(get(:user)).to have_http_status(302) }
    end
  end

  context 'as a user' do
    before(:each) do
      sign_in create(:user_account)
    end

    describe 'GET #guest' do
      it { expect(get(:guest)).to have_http_status(302) }
    end

    describe 'GET #user' do
      it { expect(get(:user)).to have_http_status(200) }
    end
  end

  context 'as an admin' do
    before(:each) do
      sign_in create(:admin_account)
    end

    describe 'GET #guest' do
      it { expect(get(:guest)).to have_http_status(302) }
    end

    describe 'GET #user' do
      it { expect(get(:user)).to have_http_status(200) }
    end
  end
end
