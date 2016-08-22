require 'rails_helper'

RSpec.describe Teacher::ClassroomStudentsController, type: :controller do
  let(:classroom) { create(:classroom) }
  let(:teacher) { create(:teacher) }
  let(:valid_attributes) {
    { students_attributes: [{
      first_name: 'foo',
      last_name: 'bar'
    }] }
  }

  describe 'GET #edit' do
    context 'as a guest' do
      it 'redirects' do
        get :edit, params: { id: classroom.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      before(:each) { sign_in teacher }

      context 'approved in the school' do
        before :each do
          create(:school_user, school: classroom.school, user: teacher,
                               approved: true)
        end

        it 'is a success' do
          get :edit, params: { id: classroom.id }
          expect(response).to have_http_status(200)
        end
      end

      context 'not approved in the school' do
        before :each do
          create(:school_user, school: classroom.school, user: teacher,
                               approved: false)
        end

        it 'redirects' do
          get :edit, params: { id: classroom.id }
          expect(response).to have_http_status(302)
        end
      end

      context 'from another the school' do
        before :each do
          create(:school_user, user: teacher, approved: true)
        end

        it 'redirects' do
          get :edit, params: { id: classroom.id }
          expect(response).to have_http_status(302)
        end
      end

      context 'without a school' do
        it 'redirects' do
          get :edit, params: { id: classroom.id }
          expect(response).to have_http_status(302)
        end
      end
    end
  end

  describe 'PATCH #update' do
    before :each do
      create(:school_user, user: teacher, school: classroom.school,
                           approved: true)
      sign_in teacher
    end

    context 'creating students' do
      it 'increases the students_count cache' do
        expect(classroom.reload.students_count).to eq(0)
        patch :update, params: { id: classroom.id, classroom: valid_attributes }
        expect(classroom.reload.students_count).to eq(1)
      end

      it 'creates a new student' do
        expect(User.where(role: 'student').size).to eq(0)
        patch :update, params: { id: classroom.id, classroom: valid_attributes }
        expect(User.where(role: 'student').size).to eq(1)
      end

      it 'creates a confirmed student' do
        patch :update, params: { id: classroom.id, classroom: valid_attributes }
        expect(User.where(role: 'student').first.confirmed_at).not_to be_nil
      end

      it 'creates an approved student' do
        patch :update, params: { id: classroom.id, classroom: valid_attributes }
        expect(User.where(role: 'student').first.approved).to be_truthy
      end

      it 'redirects' do
        patch :update, params: { id: classroom.id, classroom: valid_attributes }
        expect(response).to have_http_status(302)
      end
    end

    context 'updating students' do
      let(:student) { create(:classroom_student, classroom: classroom).user }

      it 'updates the student first name' do
        patch :update, params: { id: classroom.id, classroom: {
          students_attributes: [{ id: student.id, first_name: 'foo' }]
        } }
        expect(student.reload.first_name).to eq('foo')
      end
    end

    context 'destroying a student' do
      let!(:student) { create(:classroom_student, classroom: classroom).user }

      it 'decreases the student_count cache' do
        expect(classroom.students_count).to eq(1)
        patch :update, params: { id: classroom.id, classroom: {
          students_attributes: [{ id: student.id, _destroy: '1' }]
        } }
        expect(classroom.reload.students_count).to eq(0)
      end

      it 'destroys the student' do
        expect {
          patch :update, params: { id: classroom.id, classroom: {
            students_attributes: [{ id: student.id, _destroy: '1' }]
          } }
        }.to change(User, :count).by(-1)
      end
    end
  end
end
