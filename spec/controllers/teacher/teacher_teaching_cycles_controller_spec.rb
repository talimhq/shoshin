require 'rails_helper'

RSpec.describe Teacher::TeacherTeachingCyclesController, type: :controller do
  let(:teaching_cycle) { create(:teaching_cycle) }
  let(:teacher) { create(:teacher) }
  let!(:teacher_teaching_cycle) { create(:teacher_teaching_cycle, teaching_cycle: teaching_cycle) }
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
      before(:each) { sign_in teacher.account }

      it 'is a success' do
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
        }.not_to change(TeacherTeachingCycle, :count)
      end
    end

    context 'as a teacher' do
      before { sign_in teacher.account }

      it 'creates a user_teaching_cycle' do
        expect {
          post :create, params: { teaching_cycle: valid_attributes }
        }.to change(TeacherTeachingCycle, :count).by(1)
      end

      it 'does not add the same teaching cycle twice' do
        teaching_cycle = create(:teacher_teaching_cycle, teacher: teacher).teaching_cycle
        expect {
          post :create, params: {
            teaching_cycle: {
              teaching_id: teaching_cycle.teaching_id,
              cycle_id: teaching_cycle.cycle_id
            }
          }
        }.not_to change(TeacherTeachingCycle, :count) end
    end
  end

  describe 'DELETE :destroy' do
    context 'as a guest' do
      it 'does not destroy the user_teaching_cycle' do
        expect {
          delete :destroy, params: { id: teacher_teaching_cycle.id }
        }.not_to change(TeacherTeachingCycle, :count)
      end
    end

    context 'as a teacher' do
      before(:each) { sign_in teacher.account }

      it 'does not destroy other user_teaching_cycle' do
        expect {
          delete :destroy, params: { id: teacher_teaching_cycle.id }
        }.not_to change(TeacherTeachingCycle, :count)
      end

      it 'destroys the current user user_teaching_cycle' do
        teacher_teaching_cycle.update(teacher: teacher)
        expect {
          delete :destroy, params: { id: teacher_teaching_cycle.id }
        }.to change(TeacherTeachingCycle, :count).by(-1)
      end
    end
  end
end
