require 'rails_helper'

RSpec.describe Teacher::ChapterExercisesController, type: :controller do
  let!(:chapter_exercise) { create(:chapter_exercise) }
  let(:chapter) { chapter_exercise.chapter }
  let(:exercise) { chapter_exercise.exercise }
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
      it 'does not create a chapter_exercise' do
        expect {
          post :create, params: { chapter_id: chapter.id,
                                  chapter_exercise: {
                                    exercise_id: exercise2.id
                                  } }
        }.not_to change(ChapterExercise, :count)
      end
    end

    context 'as an unauthorized teacher' do
      before { sign_in create(:teacher_account) }

      it 'does not create a chapter_exercise' do
        expect {
          post :create, params: { chapter_id: chapter.id,
                                  chapter_exercise: {
                                    exercise_id: exercise2.id
                                  } }
        }.not_to change(ChapterExercise, :count)
      end
    end

    context 'as an authorized teacher' do
      before { sign_in teacher.account }

      context 'with valid data' do
        it 'creates a chapter_exercise' do
          expect {
            post :create, params: { chapter_id: chapter.id,
                                    chapter_exercise: {
                                      exercise_id: exercise2.id
                                    } }
          }.to change(ChapterExercise, :count).by(1)
        end

        it 'redirects' do
          post :create, params: { chapter_id: chapter.id,
                                  chapter_exercise: {
                                    exercise_id: exercise2.id
                                  } }
          expect(response).to have_http_status(302)
        end
      end

      context 'with invalid data' do
        it 'does not create a chapter_exercise' do
          expect {
            post :create, params: { chapter_id: chapter.id,
                                    chapter_exercise: {
                                      exercise_id: create(:exercise).id
                                    } }
          }.not_to change(ChapterExercise, :count)
        end

        it 're renders the page' do
          post :create, params: { chapter_id: chapter.id,
                                  chapter_exercise: {
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
      it 'does not update the chapter_exercise' do
        patch :update, params: { chapter_id: chapter.id, id: exercise.id,
                                 chapter_exercise: { max_tries: 7 } }
        expect(chapter_exercise.reload.max_tries).not_to eq(7)
      end
    end

    context 'as a unauthorized teacher' do
      before { sign_in create(:teacher_account) }

      it 'does not update the chapter_exercise' do
        patch :update, params: { chapter_id: chapter.id, id: exercise.id,
                                 chapter_exercise: { max_tries: 7 } }
        expect(chapter_exercise.reload.max_tries).not_to eq(7)
      end
    end

    context 'as a authorized teacher' do
      before { sign_in teacher.account }

      context 'with valid data' do
        it 'updates the chapter_exercise' do
          patch :update, params: { chapter_id: chapter.id, id: exercise.id,
                                   chapter_exercise: { max_tries: 7 } }
          expect(chapter_exercise.reload.max_tries).to eq(7)
        end

        it 'redirects' do
          patch :update, params: { chapter_id: chapter.id, id: exercise.id,
                                   chapter_exercise: { max_tries: 7 } }
          expect(response).to have_http_status(302)
        end
      end

      context 'with invalid data' do
        it 'does not update the chapter_exercise' do
          patch :update, params: { chapter_id: chapter.id, id: exercise.id,
                                   chapter_exercise: { exercise_id: '' } }
          expect(chapter_exercise.reload.exercise).not_to be_nil
        end

        it 're renders the page' do
          patch :update, params: { chapter_id: chapter.id, id: exercise.id,
                                   chapter_exercise: { exercise_id: '' } }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as a guest' do
      it 'does not destroy the chapter_exercise' do
        expect {
          delete :destroy, params: { chapter_id: chapter.id, id: exercise.id }
        }.not_to change(ChapterExercise, :count)
      end
    end

    context 'as an unauthorized teacher' do
      before { sign_in create(:teacher_account) }

      it 'does not destroy the chapter_exercise' do
        expect {
          delete :destroy, params: { chapter_id: chapter.id, id: exercise.id }
        }.not_to change(ChapterExercise, :count)
      end
    end

    context 'as an authorized teacher' do
      before { sign_in teacher.account }

      it 'destroys the chapter_exercise' do
        expect {
          delete :destroy, params: { chapter_id: chapter.id, id: exercise.id }
        }.to change(ChapterExercise, :count).by(-1)
      end
    end
  end
end
