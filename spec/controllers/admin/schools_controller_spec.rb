require 'rails_helper'

RSpec.describe Admin::SchoolsController, type: :controller do
  let(:user) { create(:teacher) }
  let(:admin) { create(:admin) }
  let!(:school) { create(:school) }
  let(:valid_attributes) { attributes_for(:school) }

  describe 'GET #index' do
    context 'as a guest' do
      it 'redirects' do
        get :index
        expect(response).to have_http_status(302)
      end
    end

    context 'as a user' do
      before(:each) { sign_in user }

      it 'redirects' do
        get :index
        expect(response).to have_http_status(302)
      end
    end

    context 'as an admin' do
      before(:each) { sign_in admin }

      it 'is a success' do
        get :index
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET #show' do
    context 'as a guest' do
      it 'redirects' do
        get :show, params: { id: school.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a user' do
      before(:each) { sign_in user }

      it 'redirects' do
        get :show, params: { id: school.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as an admin' do
      before(:each) { sign_in admin }

      it 'is a success' do
        get :show, params: { id: school.id }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET #new' do
    context 'as a guest' do
      it 'redirects' do
        get :new
        expect(response).to have_http_status(302)
      end
    end

    context 'as a user' do
      before(:each) { sign_in user }

      it 'redirects' do
        get :new
        expect(response).to have_http_status(302)
      end
    end

    context 'as an admin' do
      before(:each) { sign_in admin }

      it 'is a success' do
        get :new
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST #create' do
    context 'as a guest' do
      it 'does not create a school' do
        expect {
          post :create, params: { school: valid_attributes }
        }.not_to change(School, :count)
      end
    end

    context 'as a user' do
      before(:each) { sign_in user }

      it 'does not create a school' do
        expect {
          post :create, params: { school: valid_attributes }
        }.not_to change(School, :count)
      end
    end

    context 'as an admin' do
      before(:each) { sign_in admin }

      context 'with valid attributes' do
        it 'creates a school' do
          expect {
            post :create, params: { school: valid_attributes }
          }.to change(School, :count).by(1)
        end

        it 'redirects' do
          post :create, params: { school: valid_attributes }
          expect(response).to have_http_status(302)
        end
      end

      context 'with invalid attributes' do
        it 'does not create a school' do
          expect {
            post :create, params: { school: { invalid: 'attributes' } }
          }.not_to change(School, :count)
        end

        it 're renders the page' do
          post :create, params: { school: { invalid: 'attributes' } }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'GET #edit' do
    context 'as a guest' do
      it 'redirects' do
        get :edit, params: { id: school.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a user' do
      before(:each) { sign_in user }

      it 'redirects' do
        get :edit, params: { id: school.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as an admin' do
      before(:each) { sign_in admin }

      it 'is a success' do
        get :edit, params: { id: school.id }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'PATCH #update' do
    context 'as a guest' do
      it 'does not update the school' do
        patch :update, params: { id: school.id, school: { name: 'foo' } }
        expect(school.reload.name).not_to eq('foo')
      end
    end

    context 'as a user' do
      before(:each) { sign_in user }

      it 'does not update the school' do
        patch :update, params: { id: school.id, school: { name: 'foo' } }
        expect(school.reload.name).not_to eq('foo')
      end
    end

    context 'as an admin' do
      before(:each) { sign_in admin }

      it 'updates the school' do
        patch :update, params: { id: school.id, school: { name: 'foo' } }
        expect(school.reload.name).to eq('foo')
      end

      it 're renders the page with invalid data' do
        patch :update, params: { id: school.id, school: { name: nil } }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as a guest' do
      it 'does not destroy the school' do
        expect {
          delete :destroy, params: { id: school.id }, format: :js
        }.not_to change(School, :count)
      end
    end

    context 'as a user' do
      before(:each) { sign_in user }

      it 'does not destroy the school' do
        expect {
          delete :destroy, params: { id: school.id }, format: :js
        }.not_to change(School, :count)
      end
    end

    context 'as an admin' do
      before(:each) { sign_in admin }

      it 'destroys the school' do
        expect {
          delete :destroy, params: { id: school.id }, format: :js
        }.to change(School, :count).by(-1)
      end
    end
  end
end
