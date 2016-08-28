require 'rails_helper'

RSpec.describe Teacher::StudentsController, type: :controller do
  describe 'GET #new' do
    let(:classroom) { create(:classroom) }

    context 'as a guest' do
      it 'redirects' do
        get :new, params: { classroom_id: classroom.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'without a school' do
        it 'redirects' do
          get :new, params: { classroom_id: classroom.id }
          expect(response).to have_http_status(302)
        end
      end

      context 'not approved in the school' do
        it 'redirects' do
          classroom.school.update(pending_teachers: [teacher])
          get :new, params: { classroom_id: classroom.id }
          expect(response).to have_http_status(302)
        end
      end

      context 'approved in the school' do
        it 'is a success' do
          classroom.school.update(teachers: [teacher])
          get :new, params: { classroom_id: classroom.id }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'POST #create' do
    let(:classroom) { create(:classroom) }
    let(:valid_attributes) {
      { account_attributes: { first_name: 'foo', last_name: 'bar'} }
    }

    context 'as a guest' do
      it 'does not create a student' do
        expect {
          post :create, params: { classroom_id: classroom.id,
                                  student: valid_attributes }
        }.not_to change(Student, :count)
      end
    end

    context 'as a teacher' do
      before do
        teacher = create(:teacher)
        sign_in teacher.account
        classroom.school.update(teachers: [teacher])
      end

      it 'creates a new student' do
        expect {
          post :create, params: { classroom_id: classroom.id,
                                  student: valid_attributes }
        }.to change(Student, :count).by(1)
      end

      it 'creates a new account' do
        expect {
          post :create, params: { classroom_id: classroom.id,
                                  student: valid_attributes }
        }.to change(Account, :count).by(1)
      end

      it 'sets a default email' do
        post :create, params: { classroom_id: classroom.id,
                                student: valid_attributes }
        expect(Account.last.email).to eq(
          "foo.bar@#{classroom.school.identifier.downcase}"
        )
      end

      it 'sets a default password' do
        post :create, params: { classroom_id: classroom.id,
                                student: valid_attributes }
        expect(Account.last.valid_password?('123456')).to be_truthy
      end

      it 'creates a confirmed student' do
        post :create, params: { classroom_id: classroom.id,
                                student: valid_attributes }
        expect(Account.last.confirmed_at).not_to be_nil
      end

      it 'redirects on succes' do
        post :create, params: { classroom_id: classroom.id,
                                student: valid_attributes }
        expect(response).to have_http_status(302)
      end

      it 're renders the page on failure' do
        post :create, params: { classroom_id: classroom.id,
                                student: { invalid: 'attributes' } }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET #edit' do
    let(:student) { create(:student) }

    context 'as a guest' do
      it 'redirects' do
        get :edit, params: { id: student.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'without a school' do
        it 'redirects' do
          get :edit, params: { id: student.id }
          expect(response).to have_http_status(302)
        end
      end

      context 'not approved in the school' do
        it 'redirects' do
          student.classroom.school.update(pending_teachers: [teacher])
          get :edit, params: { id: student.id }
          expect(response).to have_http_status(302)
        end
      end

      context 'approved in the school' do
        it 'is a success' do
          student.classroom.school.update(teachers: [teacher])
          get :edit, params: { id: student.id }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:student) { create(:student) }

    context 'as a guest' do
      it 'does not update the student' do
        patch :update, params: { id: student.id, student: { account_attributes: { id: student.account.id, first_name: 'baz' } } }
        expect(student.reload.first_name).not_to eq('baz')
      end
    end

    context 'as a teacher approved in the school' do
      before do
        teacher = create(:teacher)
        student.classroom.school.update(teachers: [teacher])
        sign_in teacher.account
      end

      it 'updates the student first_name' do
        patch :update, params: { id: student.id, student: { account_attributes: { id: student.account.id, first_name: 'baz' } } }
        expect(student.reload.first_name).to eq('baz')
      end

      it 'updates the student email' do
        patch :update, params: {
          id: student.id,
          student: {
            account_attributes: {
              id: student.account.id, email: 'foo@bar.baz'
            }
          }
        }
        expect(student.reload.email).to eq('foo@bar.baz')
      end

      it 're renders the page on error' do
        patch :update, params: {
          id: student.id, student: {
            account_attributes: { id: student.account.id, first_name: '' }
          }
        }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:student) { create(:student) }

    context 'as a guest' do
      it 'does not destroy the student' do
        expect {
          delete :destroy, params: { id: student.id }
        }.not_to change(Student, :count)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'without a school' do
        it 'does not destroy the student' do
          expect {
            delete :destroy, params: { id: student.id }
          }.not_to change(Student, :count)
        end

        it 'does not destroy the account' do
          expect {
            delete :destroy, params: { id: student.id }
          }.not_to change(Account, :count)
        end
      end

      context 'approved in the school' do
        before { student.classroom.school.update(teachers: [teacher]) }

        it 'destroys the student' do
          expect {
            delete :destroy, params: { id: student.id }
          }.to change(Student, :count).by(-1)
        end

        it 'destroys the account' do
          expect {
            delete :destroy, params: { id: student.id }
          }.to change(Account, :count).by(-1)
        end
      end
    end
  end
end
