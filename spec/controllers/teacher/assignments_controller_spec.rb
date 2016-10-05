require 'rails_helper'

RSpec.describe Teacher::AssignmentsController, type: :controller do
  let!(:assignment) { create(:assignment) }
  let(:chapter) { assignment.chapter }
  let(:exercise) { assignment.exercise }
  let(:teacher) { chapter.teacher }
  let(:exercise2) {
    create(:exercise, authorships: [build(:authorship, author: teacher)],
                      level_ids: exercise.level_ids)
  }

  describe 'GET #new' do
    context 'as a guest' do
      it 'redirects' do
        get :new, params: { chapter_id: chapter.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as an unauthorized teacher' do
      before { sign_in create(:teacher_account) }

      it 'redirects' do
        get :new, params: { chapter_id: chapter.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as an authorized teacher' do
      before { sign_in teacher.account }

      it 'is a success' do
        get :new, params: { chapter_id: chapter.id }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST #create' do
    context 'as a guest' do
      it 'does not create a assignment' do
        expect {
          post :create, params: { chapter_id: chapter.id,
                                  assignment: {
                                    exercise_id: exercise2.id
                                  } }
        }.not_to change(Assignment, :count)
      end
    end

    context 'as an unauthorized teacher' do
      before { sign_in create(:teacher_account) }

      it 'does not create a assignment' do
        expect {
          post :create, params: { chapter_id: chapter.id,
                                  assignment: {
                                    exercise_id: exercise2.id
                                  } }
        }.not_to change(Assignment, :count)
      end
    end

    context 'as an authorized teacher' do
      before { sign_in teacher.account }

      context 'with valid data' do
        it 'creates a assignment' do
          expect {
            post :create, params: { chapter_id: chapter.id,
                                    assignment: {
                                      exercise_id: exercise2.id
                                    } }
          }.to change(Assignment, :count).by(1)
        end

        it 'redirects' do
          post :create, params: { chapter_id: chapter.id,
                                  assignment: {
                                    exercise_id: exercise2.id
                                  } }
          expect(response).to have_http_status(302)
        end
      end

      context 'with invalid data' do
        it 'does not create a assignment' do
          expect {
            post :create, params: { chapter_id: chapter.id,
                                    assignment: {
                                      exercise_id: create(:exercise).id
                                    } }
          }.not_to change(Assignment, :count)
        end

        it 're renders the page' do
          post :create, params: { chapter_id: chapter.id,
                                  assignment: {
                                    exercise_id: create(:exercise).id
                                  } }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'GET #edit' do
    context 'as a guest' do
      it 'redirects' do
        get :edit, params: { chapter_id: chapter.id, id: exercise.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as an unauthorized teacher' do
      before { sign_in create(:teacher_account) }

      it 'redirects' do
        get :edit, params: { chapter_id: chapter.id, id: exercise.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as an authorized teacher' do
      before { sign_in teacher.account }

      it 'is a success' do
        get :edit, params: { chapter_id: chapter.id, id: exercise.id }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'PATCH #update' do
    context 'as a guest' do
      it 'does not update the assignment' do
        patch :update, params: { chapter_id: chapter.id, id: exercise.id,
                                 assignment: { max_tries: 7 } }
        expect(assignment.reload.max_tries).not_to eq(7)
      end
    end

    context 'as a unauthorized teacher' do
      before { sign_in create(:teacher_account) }

      it 'does not update the assignment' do
        patch :update, params: { chapter_id: chapter.id, id: exercise.id,
                                 assignment: { max_tries: 7 } }
        expect(assignment.reload.max_tries).not_to eq(7)
      end
    end

    context 'as a authorized teacher' do
      before { sign_in teacher.account }

      context 'with valid data' do
        it 'updates the assignment' do
          patch :update, params: { chapter_id: chapter.id, id: exercise.id,
                                   assignment: { max_tries: 7 } }
          expect(assignment.reload.max_tries).to eq(7)
        end

        it 'redirects' do
          patch :update, params: { chapter_id: chapter.id, id: exercise.id,
                                   assignment: { max_tries: 7 } }
          expect(response).to have_http_status(302)
        end
      end

      context 'with invalid data' do
        it 'does not update the assignment' do
          patch :update, params: { chapter_id: chapter.id, id: exercise.id,
                                   assignment: { exercise_id: '' } }
          expect(assignment.reload.exercise).not_to be_nil
        end

        it 're renders the page' do
          patch :update, params: { chapter_id: chapter.id, id: exercise.id,
                                   assignment: { exercise_id: '' } }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as a guest' do
      it 'does not destroy the assignment' do
        expect {
          delete :destroy, params: { chapter_id: chapter.id, id: exercise.id }
        }.not_to change(Assignment, :count)
      end
    end

    context 'as an unauthorized teacher' do
      before { sign_in create(:teacher_account) }

      it 'does not destroy the assignment' do
        expect {
          delete :destroy, params: { chapter_id: chapter.id, id: exercise.id }
        }.not_to change(Assignment, :count)
      end
    end

    context 'as an authorized teacher' do
      before { sign_in teacher.account }

      it 'destroys the assignment' do
        expect {
          delete :destroy, params: { chapter_id: chapter.id, id: exercise.id }
        }.to change(Assignment, :count).by(-1)
      end
    end
  end
end
