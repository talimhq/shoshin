require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let!(:user1) { create(:user) }

  describe 'GET #index' do
    context 'as a guest' do
      it 'redirects' do
        get :index
        expect(response).to have_http_status(302)
      end
    end

    context 'as a user' do
      before(:each) { sign_in create(:user) }

      it 'redirects' do
        get :index
        expect(response).to have_http_status(302)
      end
    end

    context 'as an admin' do
      before(:each) { sign_in create(:admin) }

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
      before(:each) { sign_in create(:user) }

      it 'redirects' do
        get :edit, params: { id: user1.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as an admin' do
      before(:each) { sign_in create(:admin) }

      it 'is a success' do
        get :edit, params: { id: user1.id }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'PATCH #update' do
    context 'as a guest' do
      it 'should not update the user' do
        patch :update, params: { id: user1.id, user: { first_name: 'foo' } }
        expect(user1.reload.first_name).not_to eq('foo')
      end
    end

    context 'as a user' do
      before(:each) { create(:user) }

      it 'should not update the user' do
        patch :update, params: { id: user1.id, user: { first_name: 'foo' } }
        expect(user1.reload.first_name).not_to eq('foo')
      end
    end

    context 'as an admin' do
      before(:each) { sign_in create(:admin) }

      it 'updates the user first name' do
        patch :update, params: { id: user1.id, user: { first_name: 'foo' } }
        expect(user1.reload.first_name).to eq('foo')
      end

      it 'updates the approved status' do
        user1.update(approved: false)
        patch :update, params: { id: user1.id, user: { approved: true } }
        expect(user1.reload.approved).to be_truthy
      end

      it 'associates the user with a school' do
        school = create(:school)
        patch :update, params: {
          id: user1.id,
          user: {
            school_user_attributes: {
              school_id: school.id,
              approved: true
            }
          }
        }
        expect(user1.reload.school).to eq(school)
      end

      it 'removes a user from a school' do
        school_user = create(:school_user, user: user1)
        patch :update, params: {
          id: user1.id,
          user: {
            school_user_attributes: {
              id: school_user.id,
              _destroy: true
            }
          }
        }
        expect(user1.reload.school).to be_nil
      end

      it 're renders the form with invalid data' do
        patch :update, params: { id: user1.id, user: { first_name: nil } }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as a guest' do
      it 'is unauthorized redirects' do
        delete :destroy, params: { id: user1.id }, format: :js
        expect(response).to have_http_status(401)
      end

      it 'does not destroy the user' do
        expect {
          delete :destroy, params: { id: user1.id }, format: :js
        }.not_to change(User, :count)
      end
    end

    context 'as a user' do
      before(:each) { sign_in create(:user) }

      it 'redirects' do
        delete :destroy, params: { id: user1.id }, format: :js
        expect(response).to have_http_status(302)
      end

      it 'does not destroy the user' do
        expect {
          delete :destroy, params: { id: user1.id }, format: :js
        }.not_to change(User, :count)
      end
    end

    context 'as an admin' do
      before(:each) { sign_in create(:admin) }

      it 'is a success' do
        delete :destroy, params: { id: user1.id }, format: :js
        expect(response).to have_http_status(200)
      end

      it 'destroys the user' do
        expect {
          delete :destroy, params: { id: user1.id }, format: :js
        }.to change(User, :count).by(-1)
      end
    end
  end
end
