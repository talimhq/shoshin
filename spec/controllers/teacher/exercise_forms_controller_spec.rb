require 'rails_helper'

describe Teacher::ExerciseFormsController, type: :controller do
  let(:answer) { create(:answers_input) }
  let(:exercise) { answer.question.exercise }
  let(:exercise_form) { create(:teacher_exercise_form, exercise: exercise) }
  let(:valid_attributes) {
    { answer.id.to_s => answer.content }
  }

  describe 'GET #new' do
    context 'as a guest' do
      it 'should redirect' do
        get(:new, params: { id: exercise.id })
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before(:each) { sign_in teacher.account }

      context 'who is not the author' do
        context 'and the exercise is shared' do
          it 'should be a success' do
            get(:new, params: { id: exercise.id })
            expect(response).to have_http_status(200)
          end
        end

        context 'and the exercise is not shared' do
          before(:each) { exercise.update(shared: false) }

          it 'should redirect' do
            get(:new, params: { id: exercise.id })
            expect(response).to have_http_status(302)
          end
        end
      end

      context 'who is the author' do
        before(:each) { exercise.update(authors: [teacher], shared: false) }

        it 'should be a success' do
          get(:new, params: { id: exercise.id })
          expect(response).to have_http_status(200)
        end
      end
    end

    context 'as a student' do
      before(:each) { sign_in create(:student_account) }

      it 'should redirect' do
        get :new, params: { id: exercise.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a parent' do
      before { sign_in create(:parent_account) }

      it 'should redirect' do
        get :new, params: { id: exercise.id }
        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'POST #create' do
    context 'as a guest' do
      it 'should redirect' do
        post :create, params: { id: exercise.id, answers: valid_attributes }
        expect(response).to have_http_status(302)
      end

      it 'should not create a new TeacherExerciseForm' do
        expect {
          post :create, params: { id: exercise.id, answers: valid_attributes }
        }.not_to change(TeacherExerciseForm, :count)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before(:each) { sign_in teacher.account }

      context 'who is not the author' do
        context 'and the exercise is shared' do
          it 'should redirect' do
            post :create, params: { id: exercise.id, answers: valid_attributes }
            expect(response).to have_http_status(302)
          end

          it 'create an TeacherExerciseForm' do
            expect {
              post :create, params: { id: exercise.id, answers: valid_attributes }
            }.to change(TeacherExerciseForm, :count).by(1)
          end
        end

        context 'and the exercise is not shared' do
          before(:each) { exercise.update(shared: false) }

          it 'should redirect' do
            post :create, params: { id: exercise.id, answers: valid_attributes }
            expect(response).to have_http_status(302)
          end

          it 'does not create an TeacherExerciseForm' do
            expect {
              post :create, params: { id: exercise.id, answers: valid_attributes }
            }.not_to change(TeacherExerciseForm, :count)
          end
        end
      end

      context 'who is the author' do
        before(:each) { exercise.update(authors: [teacher], shared: false) }

        it 'should redirect' do
          post :create, params: { id: exercise.id, answers: valid_attributes }
          expect(response).to have_http_status(302)
        end

        it 'create an TeacherExerciseForm' do
          expect {
            post :create, params: { id: exercise.id, answers: valid_attributes }
          }.to change(TeacherExerciseForm, :count).by(1)
        end
      end
    end

    context 'as a student' do
      before(:each) { sign_in create(:student_account) }

      it 'should redirect' do
        post :create, params: { id: exercise.id, answers: valid_attributes }
        expect(response).to have_http_status(302)
      end

      it 'does not create an TeacherExerciseForm' do
        expect {
          post :create, params: { id: exercise.id, answers: valid_attributes }
        }.not_to change(TeacherExerciseForm, :count)
      end
    end

    context 'as a parent' do
      before(:each) { sign_in create(:parent_account) }

      it 'should redirect' do
        post :create, params: { id: exercise.id, answers: valid_attributes }
        expect(response).to have_http_status(302)
      end

      it 'does not create an TeacherExerciseForm' do
        expect {
          post :create, params: { id: exercise.id, answers: valid_attributes }
        }.not_to change(TeacherExerciseForm, :count)
      end
    end
  end

  describe 'GET #show' do
    context 'as a guest' do
      it 'should redirect' do
        get :show, params: { exercise_id: exercise_form.exercise_id,
                             id: exercise_form.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before(:each) { sign_in teacher.account }

      context 'accessing someone else exercise_form' do
        it 'should redirect' do
          get :show, params: { exercise_id: exercise_form.exercise_id,
                               id: exercise_form.id }
          expect(response).to have_http_status(302)
        end
      end

      context 'accessing their exercise_form' do
        before(:each) { exercise_form.update(teacher: teacher) }

        it 'should be a success' do
          get :show, params: { exercise_id: exercise_form.exercise_id,
                               id: exercise_form.id }
          expect(response).to have_http_status(200)
        end
      end
    end
  end
end
