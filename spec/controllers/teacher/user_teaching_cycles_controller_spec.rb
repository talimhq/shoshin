require 'rails_helper'

RSpec.describe Teacher::UserTeachingCyclesController, type: :controller do
  let(:teaching_cycle) { create(:teaching_cycle) }
  let(:teacher) { create(:teacher) }
  let!(:user_teaching_cycle) { create(:user_teaching_cycle) }
  let(:valid_attributes) {
    {
      teaching_id: teaching_cycle.teaching_id,
      cycle_id: teaching_cycle.cycle_id
    }
  }

  describe 'GET #index' do
    context 'as a guest' do
      it 'redirects' do
        get :index
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      before(:each) { sign_in teacher }

      it 'redirects' do
        get :index
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST #create' do
    context 'as a guest' do
      it 'does not create a user_teaching_cycle' do
        expect {
          post :create, params: { teaching_cycle: valid_attributes }
        }.not_to change(UserTeachingCycle, :count)
      end
    end

    context 'as a teacher' do
      before(:each) { sign_in teacher }

      it 'creates a user_teaching_cycle' do
        expect {
          post :create, params: { teaching_cycle: valid_attributes }
        }.to change(teacher.user_teaching_cycles, :count).by(1)
      end

      it 'does not add the same teaching cycle twice' do
        teaching_cycle = create(:user_teaching_cycle, user: teacher).teaching_cycle
        expect {
          post :create, params: {
            teaching_cycle: {
              teaching_id: teaching_cycle.teaching_id,
              cycle_id: teaching_cycle.cycle_id
            }
          }
        }.not_to change(teacher.user_teaching_cycles, :count)
      end
    end
  end

  describe 'DELETE :destroy' do
    context 'as a guest' do
      it 'does not destroy the user_teaching_cycle' do
        expect {
          delete :destroy, params: { id: user_teaching_cycle.id }
        }.not_to change(UserTeachingCycle, :count)
      end
    end

    context 'as a teacher' do
      before(:each) { sign_in teacher }

      it 'does not destroy other user_teaching_cycle' do
        expect {
          delete :destroy, params: { id: user_teaching_cycle.id }
        }.not_to change(UserTeachingCycle, :count)
      end

      it 'destroys the current user user_teaching_cycle' do
        user_teaching_cycle.update(user: teacher)
        expect {
          delete :destroy, params: { id: user_teaching_cycle.id }
        }.to change(teacher.user_teaching_cycles, :count).by(-1)
      end
    end
  end
end
