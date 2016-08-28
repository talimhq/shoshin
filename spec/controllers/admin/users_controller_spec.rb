require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let!(:user1) { create(:user_account) }

  describe 'GET #index' do
    context 'as a guest' do
      it 'redirects' do
        get :index
        expect(response).to have_http_status(302)
      end
    end

    context 'as a user' do
      before(:each) { sign_in create(:user_account) }

      it 'redirects' do
        get :index
        expect(response).to have_http_status(302)
      end
    end

    context 'as an admin' do
      before(:each) { sign_in create(:admin_account) }

      it 'is a success' do
        get :index
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET #edit' do
    context 'as a guest' do
      it 'redirects' do
        get :edit, params: { id: user1.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a user' do
      before(:each) { sign_in create(:user_account) }

      it 'redirects' do
        get :edit, params: { id: user1.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as an admin' do
      before(:each) { sign_in create(:admin_account) }

      it 'is a success' do
        get :edit, params: { id: user1.id }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'PATCH #update' do
    context 'as a guest' do
      it 'should not update the user' do
        patch :update, params: { id: user1.id, account: { first_name: 'foo' } }
        expect(user1.reload.first_name).not_to eq('foo')
      end
    end

    context 'as a user' do
      before(:each) { create(:user_account) }

      it 'should not update the user' do
        patch :update, params: { id: user1.id, account: { first_name: 'foo' } }
        expect(user1.reload.first_name).not_to eq('foo')
      end
    end

    context 'as an admin' do
      before(:each) { sign_in create(:admin_account) }

      it 'updates the user first name' do
        patch :update, params: { id: user1.id, account: { first_name: 'foo' } }
        expect(user1.reload.first_name).to eq('foo')
      end

      it 're renders the form with invalid data' do
        patch :update, params: { id: user1.id, account: { first_name: nil } }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as a guest' do
      it 'is unauthorized' do
        delete :destroy, params: { id: user1.id }, format: :js
        expect(response).to have_http_status(401)
      end

      it 'does not destroy the user' do
        expect {
          delete :destroy, params: { id: user1.id }, format: :js
        }.not_to change(Account, :count)
      end
    end

    context 'as a user' do
      before(:each) { sign_in create(:user_account) }

      it 'redirects' do
        delete :destroy, params: { id: user1.id }, format: :js
        expect(response).to have_http_status(302)
      end

      it 'does not destroy the user' do
        expect {
          delete :destroy, params: { id: user1.id }, format: :js
        }.not_to change(Account, :count)
      end
    end

    context 'as an admin' do
      before(:each) { sign_in create(:admin_account) }

      it 'is a success' do
        delete :destroy, params: { id: user1.id }, format: :js
        expect(response).to have_http_status(200)
      end

      it 'destroys the user' do
        expect {
          delete :destroy, params: { id: user1.id }, format: :js
        }.to change(Account, :count).by(-1)
      end
    end
  end
end
