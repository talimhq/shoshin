require 'rails_helper'

RSpec.describe PublicSchoolsController, type: :controller do
  let(:user) { create(:user_account) }
  let(:valid_attributes) { attributes_for(:school) }

  describe 'GET #new' do
    context 'as a guest' do
      it 'is a success' do
        get :new
        expect(response).to have_http_status(200)
      end
    end

    context 'as a user' do
      before(:each) { sign_in user }

      it 'is a success' do
        get :new
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST #create' do
    context 'as a guest' do
      it 'creates a new school' do
        expect {
          post :create, params: { school: valid_attributes }
        }.to change(School, :count).by(1)
      end
    end

    context 'as a user' do
      before(:each) { sign_in user }

      it 'creates a new school' do
        expect {
          post :create, params: { school: valid_attributes }
        }.to change(School, :count).by(1)
      end

      it 're renders page with invalid data' do
        post :create, params: { school: { invalid: 'attributes' } }
        expect(response).to have_http_status(200)
      end
    end
    context 'as a guest' do
      it 'creates a new school' do
        expect {
          post :create, params: { school: valid_attributes }
        }.to change(School, :count).by(1)
      end

      it 're renders page with invalid data' do
        post :create, params: { school: { invalid: 'attributes' } }
        expect(response).to have_http_status(200)
      end
    end
  end
end
