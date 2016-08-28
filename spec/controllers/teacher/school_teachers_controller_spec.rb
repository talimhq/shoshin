require 'rails_helper'

RSpec.describe Teacher::SchoolTeachersController, type: :controller do
  let(:school) { create(:school) }
  let!(:school_teacher) { create(:unapproved_school_teacher) }

  describe 'GET #new' do
    context 'as a guest' do
      it 'redirects' do
        get :new
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher without a school' do
      before { sign_in create(:teacher_account) }

      it 'is a success' do
        get :new
        expect(response).to have_http_status(200)
      end
    end

    context 'as a teacher with a school' do
      before { sign_in create(:teacher, school: school).account }

      it 'redirects' do
        get :new
        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'POST #create' do
    context 'as a guest' do
      it 'does not create a school_teacher' do
        expect {
          post :create, params: { school_teacher: { school_id: school.id } }
        }.not_to change(SchoolTeacher, :count)
      end
    end

    context 'as a teacher without a school' do
      before { sign_in create(:teacher_account) }

      it 'creates a new school_teacher' do
        expect {
          post :create, params: { school_teacher: { school_id: school.id } }
        }.to change(SchoolTeacher, :count).by(1)
      end

      it 'creates a new unapproved school_user' do
        expect {
          post :create, params: { school_teacher: { school_id: school.id } }
        }.to change(school.pending_school_teachers, :count).by(1)
      end
    end

    context 'as a teacher with a school' do
      before { sign_in create(:teacher, school: school).account }

      it 'does not create a new school_teacher' do
        expect {
          post :create, params: { school_teacher: { school_id: school.id } }
        }.not_to change(SchoolTeacher, :count)
      end
    end
  end

  describe 'PATCH #update' do
    context 'as a guest' do
      it 'does not update the school_teacher' do
        patch :update, params: { id: school_teacher.id }
        expect(school_teacher.reload.approved).to be_falsy
      end
    end

    context 'as the teacher who made the request' do
      before { sign_in school_teacher.teacher.account }

      it 'does not update the school_teacher' do
        patch :update, params: { id: school_teacher.id }
        expect(school_teacher.reload.approved).to be_falsy
      end
    end

    context 'as a teacher from that school' do
      before do
        teacher = create(:school_teacher, school: school_teacher.school ).teacher
        sign_in teacher.account
      end

      it 'updates the school_teacher' do
        patch :update, params: { id: school_teacher.id }
        expect(school_teacher.reload.approved).to be_truthy
      end
    end

    context 'as a teacher from another school' do
      before { sign_in create(:teacher, school: school).account }

      it 'does not update the school_user' do
        patch :update, params: { id: school_teacher.id }
        expect(school_teacher.reload.approved).to be_falsy
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as a guest' do
      it 'does not destroy the school_teacher' do
        expect {
          delete :destroy, params: { id: school_teacher.id }
        }.not_to change(SchoolTeacher, :count)
      end
    end

    context 'as the teacher who made the request' do
      before { sign_in school_teacher.teacher.account }

      it 'destroys the school_teacher' do
        expect {
          delete :destroy, params: { id: school_teacher.id }
        }.to change(SchoolTeacher, :count).by(-1)
      end
    end

    context 'as a teacher from the school' do
      before do
        teacher = create(:school_teacher, school: school_teacher.school).teacher
        sign_in teacher.account
      end

      it 'destroys the school_teacher' do
        expect {
          delete :destroy, params: { id: school_teacher.id }
        }.to change(SchoolTeacher, :count).by(-1)
      end
    end

    context 'as a teacher from another school' do
      before { sign_in create(:teacher, school: school).account }

      it 'does not destroy the school_teacher' do
        expect {
          delete :destroy, params: { id: school_teacher.id }
        }.not_to change(SchoolTeacher, :count)
      end
    end
  end
end
