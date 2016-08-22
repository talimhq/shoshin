require 'rails_helper'

RSpec.describe Teacher::AbilitySetsController, type: :controller do
  let(:teaching_cycle) { create(:teaching_cycle) }

  describe 'GET #index' do
    context 'as a guest' do
      it 'should redirect' do
        get :index, params: { teaching_cycle_id: teaching_cycle.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      before(:each) { sign_in create(:teacher) }

      it 'should redirect' do
        get :index, params: { teaching_cycle_id: teaching_cycle.id }
        expect(response).to have_http_status(200)
      end
    end
  end
end
