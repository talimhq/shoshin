require 'rails_helper'

describe Admin::TeachingCyclesController, type: :controller do
  let(:teaching_cycle) { create(:teaching_cycle) }

  describe 'GET #show' do
    context 'as a guest' do
      it 'redirects' do
        get :show, params: { id: teaching_cycle.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a user' do
      before(:each) { sign_in create(:user) }

      it 'redirects' do
        get :show, params: { id: teaching_cycle.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as an admin' do
      before(:each) { sign_in create(:admin) }

      it 'is a success' do
        get :show, params: { id: teaching_cycle.id }
        expect(response).to have_http_status(200)
      end
    end
  end
end
