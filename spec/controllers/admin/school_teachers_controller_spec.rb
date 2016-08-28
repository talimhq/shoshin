require 'rails_helper'

RSpec.describe Admin::SchoolTeachersController, type: :controller do
  let!(:school_teacher) { create(:school_teacher, approved: false) }
  let(:school) { school_teacher.school }
  let(:teacher) { school_teacher.teacher }

  describe 'PATCH #update' do
    it 'updates the school_teacher to true' do
      patch :update, params: { school_id: school.id, teacher_id: teacher.id }
      expect(school_teacher.reload.approved).to be_truthy
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the school_teacher' do
      expect {
        delete :destroy, params: { school_id: school.id, teacher_id: teacher.id }
      }.to change(SchoolTeacher, :count).by(-1)
    end
  end
end
