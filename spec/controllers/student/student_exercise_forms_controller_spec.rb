require 'rails_helper'

RSpec.describe Student::StudentExerciseFormsController, type: :controller do
  let(:assignment) { create(:assignment) }
  let(:exercise_form) { create(:student_exercise_form) }

  describe 'GET #new' do
    context 'as a guest' do
      it 'redirects' do
        get :new, params: { assignment_id: assignment.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a student' do
      let(:student) { create(:student) }
      before { sign_in student.account }

      context 'not from the group' do
        it 'redirects' do
          get :new, params: { assignment_id: assignment.id }
          expect(response).to have_http_status(302)
        end
      end

      context 'from the group' do
        before { assignment.group.update(students: [student]) }

        it 'is a success' do
          get :new, params: { assignment_id: assignment.id }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'POST #create' do
    let(:student) { create(:student) }

    before do
      sign_in student.account
      assignment.group.update(students: [student])
    end

    context 'input questions' do
      let(:answer) { create(:answers_input) }
      let(:question) { answer.question }

      before { question.update(exercise: assignment.exercise) }

      it 'creates a new form' do
        expect {
          post :create, params: { assignment_id: assignment.id, answers: { question.id.to_s => answer.content } }
        }.to change(student.student_exercise_forms, :count).by(1)
      end

      it 'sets a score of 1/1 with correct answers' do
        post :create, params: { assignment_id: assignment.id, answers: { question.id.to_s => answer.content } }
        expect(student.student_exercise_forms.first.score).to eq('1/1')
      end

      it 'sets a score of 0/1 with incorrect answers' do
        post :create, params: { assignment_id: assignment.id, answers: { question.id.to_s => 'wrong answer' } }
        expect(student.student_exercise_forms.first.score).to eq('0/1')
      end
    end

    context 'single choice questions' do
      let!(:answer1) { create(:answers_single_choice, correct: true) }
      let(:question) { answer1.question }
      let!(:answer2) { create(:answers_single_choice, correct: false, question: question) }

      before { question.update(exercise: assignment.exercise) }

      it 'creates a new form' do
        expect {
          post :create, params: { assignment_id: assignment.id, answers: { question.id.to_s => answer1.content } }
        }.to change(student.student_exercise_forms, :count).by(1)
      end

      it 'sets a score of 1/1 with correct answers' do
        post :create, params: { assignment_id: assignment.id, answers: { question.id.to_s => answer1.content } }
        expect(student.student_exercise_forms.first.score).to eq('1/1')
      end

      it 'sets a score of 0/1 with incorrect answers' do
        post :create, params: { assignment_id: assignment.id, answers: { question.id.to_s => answer2.content } }
        expect(student.student_exercise_forms.first.score).to eq('0/1')
      end
    end

    context 'multiple choice questions' do
      let!(:answer1) { create(:answers_multiple_choice, correct: true) }
      let!(:question) { answer1.question }
      let!(:answer2) { create(:answers_multiple_choice, correct: false, question: question) }
      let!(:answer3) { create(:answers_multiple_choice, correct: true, question: question) }

      before { question.update(exercise: assignment.exercise) }

      it 'creates a new form' do
        expect {
          post :create, params: { assignment_id: assignment.id, answers: { question.id.to_s => [answer1.content] } }
        }.to change(student.student_exercise_forms, :count).by(1)
      end

      it 'sets a score of 1/1 with all correct answers' do
        post :create, params: { assignment_id: assignment.id, answers: { question.id.to_s => [answer1.content, answer3.content] } }
        expect(student.student_exercise_forms.first.score).to eq('1/1')
      end

      it 'sets a score of 0/1 with incorrect answers' do
        post :create, params: { assignment_id: assignment.id, answers: { question.id.to_s => [answer2.content] } }
        expect(student.student_exercise_forms.first.score).to eq('0/1')
      end

      it 'sets a score of 0/1 with missing correct answers' do
        post :create, params: { assignment_id: assignment.id, answers: { question.id.to_s => [answer1.content] } }
        expect(student.student_exercise_forms.first.score).to eq('0/1')
      end
    end
  end

  describe 'GET #show' do
    context 'as a guest' do
      it 'redirects' do
        get :show, params: { id: exercise_form.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a student' do
      let(:student) { create(:student) }
      before { sign_in student.account }

      context 'who does not own the form' do
        it 'redirects' do
          get :show, params: { id: exercise_form.id }
          expect(response).to have_http_status(302)
        end
      end

      context 'who owns the form' do
        before { exercise_form.update(student: student) }

        it 'is a success' do
          get :show, params: { id: exercise_form.id }
          expect(response).to have_http_status(200)
        end
      end
    end
  end
end
