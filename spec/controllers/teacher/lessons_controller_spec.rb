require 'rails_helper'

RSpec.describe Teacher::LessonsController, type: :controller do
  let!(:lesson) { create(:lesson) }
  let(:valid_attributes) {
    attributes_for(:lesson).merge(teaching_id: create(:teaching).id)
  }

  describe 'GET #index' do
    context 'as a guest' do
      it 'redirects' do
        get :index
        expect(response).to have_http_status(302)
      end
    end

    context 'as a student' do
      before { sign_in create(:student_account) }

      it 'redirects' do
        get :index
        expect(response).to have_http_status(302)
      end
    end

    context 'as a parent' do
      before { sign_in create(:parent_account) }

      it 'redirects' do
        get :index
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      before { sign_in create(:teacher_account) }

      it 'is a success' do
        get :index
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET #show' do
    context 'as a guest' do
      it 'redirects' do
        get :show, params: { id: lesson.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a student' do
      before { sign_in create(:student_account) }

      it 'redirects' do
        get :show, params: { id: lesson.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a parent' do
      before { sign_in create(:parent_account) }

      it 'redirects' do
        get :show, params: { id: lesson.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      before { sign_in create(:teacher_account) }

      it 'redirects' do
        get :show, params: { id: lesson.id }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET #new' do
    context 'as a guest' do
      it 'redirects' do
        get :new
        expect(response).to have_http_status(302)
      end
    end

    context 'as a student' do
      before { sign_in create(:student_account) }

      it 'redirects' do
        get :new
        expect(response).to have_http_status(302)
      end
    end

    context 'as a parent' do
      before { sign_in create(:parent_account) }

      it 'redirects' do
        get :new
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      before { sign_in create(:teacher_account) }

      it 'redirects' do
        get :new
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST #create' do
    context 'as a guest' do
      it 'does not create an lesson' do
        expect {
          post :create, params: { lesson: valid_attributes }
        }.not_to change(Lesson, :count)
      end
    end

    context 'as a student' do
      before { sign_in create(:student_account) }

      it 'does not create an lesson' do
        expect {
          post :create, params: { lesson: valid_attributes }
        }.not_to change(Lesson, :count)
      end
    end

    context 'as a parent' do
      before { sign_in create(:parent_account) }

      it 'does not create an lesson' do
        expect {
          post :create, params: { lesson: valid_attributes }
        }.not_to change(Lesson, :count)
      end
    end

    context 'as a teacher' do
      before { sign_in create(:teacher_account) }

      context 'with valid data' do
        it 'creates an lesson' do
          expect {
            post :create, params: { lesson: valid_attributes }
          }.to change(Lesson, :count).by(1)
        end

        it 'redirects' do
          post :create, params: { lesson: valid_attributes }
          expect(response).to have_http_status(302)
        end
      end

      context 'with invalid data' do
        it 'does not create the lesson' do
          expect {
            post :create, params: { lesson: { invalid: 'attribute' } }
          }.not_to change(Lesson, :count)
        end

        it 're renders the page' do
          post :create, params: { lesson: { invalid: 'attribute' } }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'GET #edit' do
    context 'as a guest' do
      it 'redirects' do
        get :edit, params: { id: lesson.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a student' do
      before { sign_in create(:student_account) }

      it 'redirects' do
        get :edit, params: { id: lesson.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a parent' do
      before { sign_in create(:parent_account) }

      it 'redirects' do
        get :edit, params: { id: lesson.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who is not an author' do
        it 'redirects' do
          get :edit, params: { id: lesson.id }
          expect(response).to have_http_status(302)
        end
      end

      context 'who is an author' do
        before { lesson.update(authors: [teacher]) }

        it 'is a success' do
          get :edit, params: { id: lesson.id }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'PATH #update' do
    context 'as a guest' do
      it 'does not update the lesson' do
        patch :update, params: { id: lesson.id, lesson: { name: 'foo' } }
        expect(lesson.reload.name).not_to eq('foo')
      end
    end

    context 'as a student' do
      before { sign_in create(:student_account) }

      it 'does not update the lesson' do
        patch :update, params: { id: lesson.id, lesson: { name: 'foo' } }
        expect(lesson.reload.name).not_to eq('foo')
      end
    end

    context 'as a parent' do
      before { sign_in create(:parent_account) }

      it 'does not update the lesson' do
        patch :update, params: { id: lesson.id, lesson: { name: 'foo' } }
        expect(lesson.reload.name).not_to eq('foo')
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who is not an author' do
        it 'does not update the lesson' do
          patch :update, params: { id: lesson.id, lesson: { name: 'foo' } }
          expect(lesson.reload.name).not_to eq('foo')
        end
      end

      context 'who is an author' do
        before { lesson.update(authors: [teacher]) }

        context 'with valid data' do
          it 'updates the lesson' do
            patch :update, params: { id: lesson.id, lesson: { name: 'foo' } }
            expect(lesson.reload.name).to eq('foo')
          end

          it 'redirects' do
            patch :update, params: { id: lesson.id, lesson: { name: 'foo' } }
            expect(response).to have_http_status(302)
          end
        end

        context 'with invalid data' do
          it 'does not update the lesson' do
            patch :update, params: { id: lesson.id, lesson: { name: '' } }
            expect(lesson.reload.name).not_to be_nil
          end

          it 're renders the page' do
            patch :update, params: { id: lesson.id, lesson: { name: '' } }
            expect(response).to have_http_status(200)
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as a guest' do
      it 'does not destroy the lesson' do
        expect {
          delete :destroy, params: { id: lesson.id }
        }.not_to change(Lesson, :count)
      end
    end

    context 'as a student' do
      before { sign_in create(:student_account) }

      it 'does not destroy the lesson' do
        expect {
          delete :destroy, params: { id: lesson.id }
        }.not_to change(Lesson, :count)
      end
    end

    context 'as a parent' do
      before { sign_in create(:parent_account) }

      it 'does not destroy the lesson' do
        expect {
          delete :destroy, params: { id: lesson.id }
        }.not_to change(Lesson, :count)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who is not an author' do
        it 'does not destroy the lesson' do
          expect {
            delete :destroy, params: { id: lesson.id }
          }.not_to change(Lesson, :count)
        end
      end

      context 'who is an author' do
        before { lesson.update(authors: [teacher]) }

        it 'destroys the lesson' do
          expect {
            delete :destroy, params: { id: lesson.id }
          }.to change(Lesson, :count).by(-1)
        end
      end
    end
  end
end
