require 'rails_helper'

RSpec.describe Teacher::TeachingCyclesController, type: :controller do
  describe 'GET #index' do
    context 'as a guest' do
      it 'redirects' do
        get :index
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      it 'is a success' do
        sign_in create(:teacher_account)
        get :index
        expect(response).to have_http_status(200)
      end
    end
  end
end
