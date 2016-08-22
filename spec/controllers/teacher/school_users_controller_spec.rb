require 'rails_helper'

describe Teacher::SchoolUsersController do
  let(:teacher) { create(:teacher) }
  let(:school) { create(:school) }

  describe 'GET #new' do
    context 'as a guest' do
      it 'redirects' do
        get :new
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      before(:each) { sign_in teacher }

      context 'without a school' do
        it 'is a success' do
          get :new
          expect(response).to have_http_status(200)
        end
      end

      context 'from a school' do
        before(:each) { create(:school_user, user: teacher) }

        it 'redirects' do
          get :new
          expect(response).to have_http_status(302)
        end
      end
    end
  end

  describe 'POST #create' do
    context 'as a guest' do
      it 'does not create a new SchoolUser' do
        expect {
          post :create, params: { school_user: { school_id: school.id } }
        }.not_to change(SchoolUser, :count)
      end
    end

    context 'as a teacher' do
      before(:each) { sign_in teacher }

      context 'without a school' do
        it 'creates a new SchoolUser' do
          expect {
            post :create, params: { school_user: { school_id: school.id } }
          }.to change(SchoolUser, :count).by(1)
        end

        it 'creates a new SchoolUser for the current user' do
          post :create, params: { school_user: { school_id: school.id } }
          expect(SchoolUser.last.user).to eq(teacher)
        end

        it 'creates a pending new SchoolUser' do
          post :create, params: { school_user: { school_id: school.id } }
          expect(SchoolUser.last.approved).to be_falsey
        end

        it 're renders the page with invalid data' do
          post :create, params: { school_user: { invalid: 'attributes' } }
          expect(response).to have_http_status(200)
        end
      end

      context 'approved in a school' do
        before(:each) { create(:school_user, user: teacher, approved: true) }

        it 'does not create a new SchoolUser' do
          expect {
            post :create, params: { school_user: { school_id: school.id } }
          }.not_to change(SchoolUser, :count)
        end
      end

      context 'not approved in a school' do
        before(:each) { create(:school_user, user: teacher, approved: false) }

        it 'does not create a new SchoolUser' do
          expect {
            post :create, params: { school_user: { school_id: school.id } }
          }.not_to change(SchoolUser, :count)
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:school_user) { create(:school_user, approved: false) }

    context 'as a guest' do
      it 'does not update the school_user status' do
        patch :update, params: { id: school_user.id }
        expect(school_user.reload.approved).to be_falsey
      end
    end

    context 'as a teacher' do
      before(:each) { sign_in teacher }

      context 'accepted in that school' do
        before :each do
          create(:school_user, user: teacher, school: school_user.school,
                               approved: true)
        end

        it 'updates the school_user status' do
          patch :update, params: { id: school_user.id }
          expect(school_user.reload.approved).to be_truthy
        end

        it 'updates the user status' do
          school_user.user.update(approved: false)
          patch :update, params: { id: school_user.id }
          expect(school_user.user.reload.approved).to be_truthy
        end
      end

      context 'not accepted in that school' do
        before :each do
          create(:school_user, user: teacher, school: school_user.school,
                               approved: false)
        end

        it 'does not update the school_user status' do
          patch :update, params: { id: school_user.id }
          expect(school_user.reload.approved).to be_falsey
        end

        it 'does not update the user status' do
          school_user.user.update(approved: false)
          patch :update, params: { id: school_user.id }
          expect(school_user.user.reload.approved).to be_falsey
        end
      end

      context 'accepted in another school' do
        before :each do
          create(:school_user, user: teacher, approved: true)
        end

        it 'does not update the school_user status' do
          patch :update, params: { id: school_user.id }
          expect(school_user.reload.approved).to be_falsey
        end

        it 'does not update the user status' do
          school_user.user.update(approved: false)
          patch :update, params: { id: school_user.id }
          expect(school_user.user.reload.approved).to be_falsey
        end
      end

      context 'not accepted in another school' do
        before :each do
          create(:school_user, user: teacher, approved: false)
        end

        it 'does not update the school_user status' do
          patch :update, params: { id: school_user.id }
          expect(school_user.reload.approved).to be_falsey
        end

        it 'does not update the user status' do
          school_user.user.update(approved: false)
          patch :update, params: { id: school_user.id }
          expect(school_user.user.reload.approved).to be_falsey
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:school_user) { create(:school_user, approved: false) }

    context 'as a guest' do
      it 'does not destroy the school_user' do
        expect {
          delete :destroy, params: { id: school_user.id }
        }.not_to change(SchoolUser, :count)
      end
    end

    context 'as a teacher' do
      before(:each) { sign_in teacher }

      it 'does not destroy the school_user' do
        expect {
          delete :destroy, params: { id: school_user.id }
        }.not_to change(SchoolUser, :count)
      end

      context 'who created the request' do
        before(:each) { school_user.update(user: teacher) }

        it 'destroys the school_user' do
          expect {
            delete :destroy, params: { id: school_user.id }
          }.to change(SchoolUser, :count).by(-1)
        end
      end

      context 'approved in that school' do
        before(:each) do
          create(:school_user, user: teacher, approved: true,
                               school: school_user.school)
        end

        it 'destroys the school_user' do
          expect {
            delete :destroy, params: { id: school_user.id }
          }.to change(SchoolUser, :count).by(-1)
        end
      end

      context 'not approved in that school' do
        before(:each) do
          create(:school_user, user: teacher, approved: false,
                               school: school_user.school)
        end

        it 'destroys the school_user' do
          expect {
            delete :destroy, params: { id: school_user.id }
          }.not_to change(SchoolUser, :count)
        end
      end

      context 'approved in another school' do
        before(:each) do
          create(:school_user, user: teacher, approved: true)
        end

        it 'destroys the school_user' do
          expect {
            delete :destroy, params: { id: school_user.id }
          }.not_to change(SchoolUser, :count)
        end
      end

      context 'not approved in another school' do
        before(:each) do
          create(:school_user, user: teacher, approved: false)
        end

        it 'destroys the school_user' do
          expect {
            delete :destroy, params: { id: school_user.id }
          }.not_to change(SchoolUser, :count)
        end
      end
    end
  end
end
