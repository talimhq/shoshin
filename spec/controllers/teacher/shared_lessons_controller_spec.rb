require 'rails_helper'

RSpec.describe Teacher::SharedLessonsController, type: :controller do
  let!(:lesson) { create(:lesson) }

  context 'GET #index' do
    context 'as a guest' do
      it 'redirects' do
        get :index
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      it 'is a success' do
        get :index
        expect(response).to have_http_status(200)
      end
    end
  end

  context 'GET #show' do
    context 'as guest' do
      it 'redirects' do
        get :show, params: { id: lesson.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'if the lesson is shared' do
        before { lesson.update(shared: true) }

        it 'is a success' do
          get :show, params: { id: lesson.id }
          expect(response).to have_http_status(200)
        end
      end

      context 'if the lesson is not shared' do
        before { lesson.update(shared: false) }

        it 'redirects if the teacher is not an author' do
          get :show, params: { id: lesson.id }
          expect(response).to have_http_status(302)
        end

        it 'is a success if the teacher is an author' do
          lesson.update(authors: [teacher])
          get :show, params: { id: lesson.id }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  context 'POST #create' do
    context 'as a guest' do
      it 'does not create a new lesson' do
        expect {
          post :create, params: { lesson_id: lesson.id }
        }.not_to change(Lesson, :count)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      it 'creates a new lesson' do
        expect {
          post :create, params: { lesson_id: lesson.id }
        }.to change(Lesson, :count).by(1)
      end

      it 'increases the popularity of the original' do
        expect(lesson.popularity).to eq(0)
        post :create, params: { lesson_id: lesson.id }
        expect(lesson.reload.popularity).to eq(1)
      end
    end
  end
end
