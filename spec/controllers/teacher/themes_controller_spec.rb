require 'rails_helper'

RSpec.describe Teacher::ThemesController, type: :controller do
  let(:teaching_cycle) { create(:teaching_cycle) }
  let(:theme) { create(:theme) }

  describe 'GET #index' do
    context 'as a guest' do
      it 'redirects' do
        get :index, params: { teaching_cycle_id: teaching_cycle.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      before(:each) { sign_in create(:teacher) }

      it 'is a success' do
        get :index, params: { teaching_cycle_id: teaching_cycle.id }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET #show' do
    context 'as a guest' do
      it 'redirects' do
        get :show, params: { id: theme.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      before(:each) { sign_in create(:teacher) }

      it 'is a success' do
        get :show, params: { id: theme.id }
        expect(response).to have_http_status(200)
      end
    end
  end
end
