require 'rails_helper'

RSpec.describe Admin::CyclesController, type: :controller do
  let!(:cycle) { create(:cycle, position: 1) }
  let!(:level) { create(:level, cycle: cycle) }
  let(:cycle2) { create(:cycle, position: 2) }
  let(:valid_attributes) {
    {
      name: Faker::Company.name,
      levels_attributes: [attributes_for(:level)]
    }
  }

  describe 'GET #index' do
    context 'as a guest' do
      it 'redirects' do
        get :index
        expect(response).to have_http_status(302)
      end
    end

    context 'as a user' do
      before { sign_in create(:user_account) }

      it 'redirects' do
        get :index
        expect(response).to have_http_status(302)
      end
    end

    context 'as an admin' do
      before { sign_in create(:admin_account) }

      it 'is a success' do
        get :index
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
      before { sign_in create(:user_account) }

      it 'redirects' do
        get :new
        expect(response).to have_http_status(302)
      end
    end

    context 'as an admin' do
      before { sign_in create(:admin_account) }

      it 'is a success' do
        get :new
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET #edit' do
    context 'as a guest' do
      it 'redirects' do
        get :edit, params: { id: cycle.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a user' do
      before { sign_in create(:user_account) }

      it 'redirects' do
        get :edit, params: { id: cycle.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as an admin' do
      before { sign_in create(:admin_account) }

      it 'is a success' do
        get :edit, params: { id: cycle.id }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST #create' do
    context 'as a guest' do
      it 'does not create a cycle' do
        expect {
          post :create, params: { cycle: valid_attributes }
        }.not_to change(Cycle, :count)
      end
    end

    context 'as a user' do
      before { sign_in create(:user_account) }

      it 'does not create a cycle' do
        expect {
          post :create, params: { cycle: valid_attributes }
        }.not_to change(Cycle, :count)
      end
    end

    context 'as an admin' do
      before { sign_in create(:admin_account) }

      context 'with valid data' do
        it 'creates a cycle' do
          expect {
            post :create, params: { cycle: valid_attributes }
          }.to change(Cycle, :count).by(1)
        end

        it 'creates a level' do
          expect {
            post :create, params: { cycle: valid_attributes }
          }.to change(Level, :count).by(1)
        end

        it 'redirects' do
          post :create, params: { cycle: valid_attributes }
          expect(response).to have_http_status(302)
        end
      end

      context 'with invalid data' do
        it 'does not create a cycle' do
          expect {
            post :create, params: { cycle: { invalid: 'attributes' } }
          }.not_to change(Cycle, :count)
        end

        it 're renders the page' do
          post :create, params: { cycle: { invalid: 'attributes' } }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'POST #sort' do
    context 'as a guest' do
      it 'does not change the cycles order' do
        post :sort, params: { cycle: [cycle2.id, cycle.id] }
        expect(Cycle.ordered).to eq([cycle, cycle2])
      end
    end

    context 'as a user' do
      before { sign_in create(:user_account) }

      it 'does not change the cycles order' do
        post :sort, params: { cycle: [cycle2.id, cycle.id] }
        expect(Cycle.ordered).not_to eq([cycle2, cycle])
      end
    end

    context 'as an admin' do
      before { sign_in create(:admin_account) }

      it 'changes the cycles order' do
        post :sort, params: { cycle: [cycle2.id, cycle.id] }
        expect(Cycle.ordered).to eq([cycle2, cycle])
      end
    end
  end

  describe 'PATCH #update' do
    context 'as a guest' do
      it 'does not update the cycle' do
        patch :update, params: { id: cycle.id, cycle: { name: 'foo' } }
        expect(cycle.reload.name).not_to eq('foo')
      end
    end

    context 'as a user' do
      before { sign_in create(:user_account) }

      it 'does not update the cycle' do
        patch :update, params: { id: cycle.id, cycle: { name: 'foo' } }
        expect(cycle.reload.name).not_to eq('foo')
      end
    end

    context 'as an admin' do
      before { sign_in create(:admin_account) }

      context 'with valid data' do
        it 'updates the cycle' do
          patch :update, params: { id: cycle.id, cycle: { name: 'foo' } }
          expect(cycle.reload.name).to eq('foo')
        end

        it 'redirects' do
          patch :update, params: { id: cycle.id, cycle: { name: 'foo' } }
          expect(response).to have_http_status(302)
        end

        it 'destroys nested levels' do
          expect {
            patch :update, params: { id: cycle.id,
                                    cycle: { levels_attributes: [
                                      { id: level.id, _destroy: true }
                                    ] } }
          }.to change(Level, :count).by(-1)
        end
      end

      context 'with invalid data' do
        it 'does not update the cycle' do
          patch :update, params: { id: cycle.id, cycle: { name: '' } }
          expect(cycle.reload.name).not_to be_nil
        end

        it 're renders the page' do
          patch :update, params: { id: cycle.id, cycle: { name: '' } }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as a guest' do
      it 'does not destroy the cycle' do
        expect {
          delete :destroy, params: { id: cycle.id }
        }.not_to change(Cycle, :count)
      end
    end

    context 'as a user' do
      before { sign_in create(:user_account) }

      it 'does not destroy the cycle' do
        expect {
          delete :destroy, params: { id: cycle.id }
        }.not_to change(Cycle, :count)
      end
    end

    context 'as an admin' do
      before { sign_in create(:admin_account) }

      it 'destroys the cycle' do
        expect {
          delete :destroy, params: { id: cycle.id }
        }.to change(Cycle, :count).by(-1)
      end

      it 'destroys nested levels' do
        expect {
          delete :destroy, params: { id: cycle.id }
        }.to change(Level, :count).by(-1)
      end

      it 'redirects' do
        delete :destroy, params: { id: cycle.id }
        expect(response).to have_http_status(302)
      end
    end
  end
end
