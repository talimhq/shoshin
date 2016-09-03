require 'rails_helper'

RSpec.describe Teacher::ExercisesController, type: :controller do
  let!(:exercise) { create(:exercise) }
  let(:valid_attributes) {
    attributes_for(:exercise).merge(teaching_id: create(:teaching).id,
                                    level_ids: [create(:level).id])
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
        get :show, params: { id: exercise.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a student' do
      before { sign_in create(:student_account) }

      it 'redirects' do
        get :show, params: { id: exercise.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a parent' do
      before { sign_in create(:parent_account) }

      it 'redirects' do
        get :show, params: { id: exercise.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      before { sign_in create(:teacher_account) }

      it 'redirects' do
        get :show, params: { id: exercise.id }
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
      it 'does not create an exercise' do
        expect {
          post :create, params: { exercise: valid_attributes }
        }.not_to change(Exercise, :count)
      end
    end

    context 'as a student' do
      before { sign_in create(:student_account) }

      it 'does not create an exercise' do
        expect {
          post :create, params: { exercise: valid_attributes }
        }.not_to change(Exercise, :count)
      end
    end

    context 'as a parent' do
      before { sign_in create(:parent_account) }

      it 'does not create an exercise' do
        expect {
          post :create, params: { exercise: valid_attributes }
        }.not_to change(Exercise, :count)
      end
    end

    context 'as a teacher' do
      before { sign_in create(:teacher_account) }

      context 'with valid data' do
        it 'creates an exercise' do
          expect {
            post :create, params: { exercise: valid_attributes }
          }.to change(Exercise, :count).by(1)
        end

        it 'redirects' do
          post :create, params: { exercise: valid_attributes }
          expect(response).to have_http_status(302)
        end
      end

      context 'with invalid data' do
        it 'does not create the exercise' do
          expect {
            post :create, params: { exercise: { invalid: 'attribute' } }
          }.not_to change(Exercise, :count)
        end

        it 're renders the page' do
          post :create, params: { exercise: { invalid: 'attribute' } }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'GET #edit' do
    context 'as a guest' do
      it 'redirects' do
        get :edit, params: { id: exercise.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a student' do
      before { sign_in create(:student_account) }

      it 'redirects' do
        get :edit, params: { id: exercise.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a parent' do
      before { sign_in create(:parent_account) }

      it 'redirects' do
        get :edit, params: { id: exercise.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who is not an author' do
        it 'redirects' do
          get :edit, params: { id: exercise.id }
          expect(response).to have_http_status(302)
        end
      end

      context 'who is an author' do
        before { exercise.update(authors: [teacher]) }

        it 'is a success' do
          get :edit, params: { id: exercise.id }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'PATH #update' do
    context 'as a guest' do
      it 'does not update the exercise' do
        patch :update, params: { id: exercise.id, exercise: { name: 'foo' } }
        expect(exercise.reload.name).not_to eq('foo')
      end
    end

    context 'as a student' do
      before { sign_in create(:student_account) }

      it 'does not update the exercise' do
        patch :update, params: { id: exercise.id, exercise: { name: 'foo' } }
        expect(exercise.reload.name).not_to eq('foo')
      end
    end

    context 'as a parent' do
      before { sign_in create(:parent_account) }

      it 'does not update the exercise' do
        patch :update, params: { id: exercise.id, exercise: { name: 'foo' } }
        expect(exercise.reload.name).not_to eq('foo')
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who is not an author' do
        it 'does not update the exercise' do
          patch :update, params: { id: exercise.id, exercise: { name: 'foo' } }
          expect(exercise.reload.name).not_to eq('foo')
        end
      end

      context 'who is an author' do
        before { exercise.update(authors: [teacher]) }

        context 'with valid data' do
          it 'updates the exercise' do
            patch :update, params: { id: exercise.id, exercise: { name: 'foo' } }
            expect(exercise.reload.name).to eq('foo')
          end

          it 'redirects' do
            patch :update, params: { id: exercise.id, exercise: { name: 'foo' } }
            expect(response).to have_http_status(302)
          end
        end

        context 'with invalid data' do
          it 'does not update the exercise' do
            patch :update, params: { id: exercise.id, exercise: { name: '' } }
            expect(exercise.reload.name).not_to be_nil
          end

          it 're renders the page' do
            patch :update, params: { id: exercise.id, exercise: { name: '' } }
            expect(response).to have_http_status(200)
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as a guest' do
      it 'does not destroy the exercise' do
        expect {
          delete :destroy, params: { id: exercise.id }
        }.not_to change(Exercise, :count)
      end
    end

    context 'as a student' do
      before { sign_in create(:student_account) }

      it 'does not destroy the exercise' do
        expect {
          delete :destroy, params: { id: exercise.id }
        }.not_to change(Exercise, :count)
      end
    end

    context 'as a parent' do
      before { sign_in create(:parent_account) }

      it 'does not destroy the exercise' do
        expect {
          delete :destroy, params: { id: exercise.id }
        }.not_to change(Exercise, :count)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who is not an author' do
        it 'does not destroy the exercise' do
          expect {
            delete :destroy, params: { id: exercise.id }
          }.not_to change(Exercise, :count)
        end
      end

      context 'who is an author' do
        before { exercise.update(authors: [teacher]) }

        it 'destroys the exercise' do
          expect {
            delete :destroy, params: { id: exercise.id }
          }.to change(Exercise, :count).by(-1)
        end
      end
    end
  end
end
