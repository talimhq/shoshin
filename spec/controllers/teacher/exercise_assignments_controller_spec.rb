require 'rails_helper'

RSpec.describe Teacher::ExerciseAssignmentsController, type: :controller do
  let(:exercise) { create(:exercise) }

  describe 'GET #new' do
    context 'as a guest' do
      it 'redirects' do
        get :new, params: { exercise_id: exercise.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who is not an author' do
        it 'redirects' do
          get :new, params: { exercise_id: exercise.id }
          expect(response).to have_http_status(302)
        end
      end

      context 'who is an author' do
        it 'is a success' do
          exercise.update(authors: [teacher])
          get :new, params: { exercise_id: exercise.id }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'POST #create' do
    let(:teacher) { create(:teacher) }
    let(:chapter) { create(:chapter) }
    before { sign_in teacher.account }

    context 'who is not an author' do
      it 'does not create the assignment' do
        expect {
          post :create, params: { exercise_id: exercise.id,
                                  assignment: { chapter_id: chapter.id } }
        }.not_to change(Assignment, :count)
      end
    end

    context 'who does not own the chapter' do
      it 'does not create the assignment' do
        exercise.update(authors: [teacher])
        expect {
          post :create, params: { exercise_id: exercise.id,
                                  assignment: { chapter_id: chapter.id } }
        }.not_to change(Assignment, :count)
      end
    end

    context 'who owns the chapter' do
      context 'with valid attributes' do
        it 'creates the assignment' do
          exercise.update(authors: [teacher])
          chapter.update(teacher: teacher)
          expect {
            post :create, params: { exercise_id: exercise.id,
                                    assignment: { chapter_id: chapter.id } }
          }.to change(Assignment, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not create duplicate assignment' do
          exercise.update(authors: [teacher])
          chapter.update(teacher: teacher)
          Assignment.create(exercise: exercise, chapter: chapter)
          expect {
            post :create, params: { exercise_id: exercise.id,
                                    assignment: { chapter_id: chapter.id } }
          }.not_to change(Assignment, :count)
        end
      end
    end
  end
end
