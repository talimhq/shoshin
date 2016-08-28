require 'rails_helper'

RSpec.describe Teacher::AuthorshipsController, type: :controller do
  let(:new_author) { create(:teacher) }
  let(:lesson) { create(:lesson) }
  let!(:authorship) { create(:authorship, editable: lesson) }

  describe 'GET #index' do
    context 'as a guest' do
      it 'redirects' do
        get :index, params: { editable_type: 'Lesson', lesson_id: lesson.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a student' do
      before { sign_in create(:student_account) }

      it 'redirects' do
        get :index, params: { editable_type: 'Lesson', lesson_id: lesson.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a parent' do
      before { sign_in create(:parent_account) }

      it 'redirects' do
        get :index, params: { editable_type: 'Lesson', lesson_id: lesson.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who is not the author' do
        it 'redirects' do
          get :index, params: { editable_type: 'Lesson', lesson_id: lesson.id }
          expect(response).to have_http_status(302)
        end
      end

      context 'who is the author' do
        before { lesson.update(authors: [teacher]) }

        it 'is a success' do
          get :index, params: { editable_type: 'Lesson', lesson_id: lesson.id }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'GET #new' do
    context 'as a guest' do
      it 'redirects' do
        get :new, params: { editable_type: 'Lesson', lesson_id: lesson.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a student' do
      before { sign_in create(:student_account) }

      it 'redirects' do
        get :new, params: { editable_type: 'Lesson', lesson_id: lesson.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a parent' do
      before { sign_in create(:parent_account) }

      it 'redirects' do
        get :new, params: { editable_type: 'Lesson', lesson_id: lesson.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who is not the author' do
        it 'redirects' do
          get :new, params: { editable_type: 'Lesson', lesson_id: lesson.id }
          expect(response).to have_http_status(302)
        end
      end

      context 'who is the author' do
        before { lesson.update(authors: [teacher]) }

        it 'is a success' do
          get :new, params: { editable_type: 'Lesson', lesson_id: lesson.id }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'POST #create' do
    context 'as a guest' do
      it 'does not create a new authorship' do
        expect {
          post :create, params: { editable_type: 'Lesson', lesson_id: lesson.id,
                                  authorship: { teacher_id: new_author.id } }
        }.not_to change(Authorship, :count)
      end
    end

    context 'as a student' do
      before { sign_in create(:student_account) }

      it 'does not create a new authorship' do
        expect {
          post :create, params: { editable_type: 'Lesson', lesson_id: lesson.id,
                                  authorship: { teacher_id: new_author.id } }
        }.not_to change(Authorship, :count)
      end
    end

    context 'as a parent' do
      before { sign_in create(:parent_account) }

      it 'does not create a new authorship' do
        expect {
          post :create, params: { editable_type: 'Lesson', lesson_id: lesson.id,
                                  authorship: { teacher_id: new_author.id } }
        }.not_to change(Authorship, :count)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who is not the author' do
        it 'does not create a new authorship' do
          expect {
            post :create, params: { editable_type: 'Lesson',
                                    lesson_id: lesson.id,
                                    authorship: { teacher_id: new_author.id } }
          }.not_to change(Authorship, :count)
        end
      end

      context 'who is the author' do
        before { lesson.update(authors: [teacher]) }

        it 'creates a new authorship' do
          expect {
            post :create, params: { editable_type: 'Lesson',
                                    lesson_id: lesson.id,
                                    authorship: { teacher_id: new_author.id } }
          }.to change(lesson.authorships, :count).by(1)
        end

        it 'does not create a duplicate authorship' do
          expect {
            post :create, params: { editable_type: 'Lesson',
                                    lesson_id: lesson.id,
                                    authorship: { teacher_id: teacher.id } }
          }.not_to change(Authorship, :count)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as a guest' do
      it 'does not destroy the authorship' do
        expect {
          delete :destroy, params: { editable_type: 'Lesson',
                                    lesson_id: lesson.id, id: authorship.id }
        }.not_to change(Authorship, :count)
      end
    end

    context 'as a student' do
      before { sign_in create(:student_account) }

      it 'does not destroy the authorship' do
        expect {
          delete :destroy, params: { editable_type: 'Lesson',
                                    lesson_id: lesson.id, id: authorship.id }
        }.not_to change(Authorship, :count)
      end
    end

    context 'as a parent' do
      before { sign_in create(:parent_account) }

      it 'does not destroy the authorship' do
        expect {
          delete :destroy, params: { editable_type: 'Lesson',
                                    lesson_id: lesson.id, id: authorship.id }
        }.not_to change(Authorship, :count)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who is not the author' do
        it 'does not destroy the authorship' do
          expect {
            delete :destroy, params: { editable_type: 'Lesson',
                                      lesson_id: lesson.id, id: authorship.id }
          }.not_to change(Authorship, :count)
        end
      end

      context 'who is the author' do
        before { lesson.update(authors: [teacher]) }

        it 'destroys the authorship' do
          authorship = lesson.authorships.first
          expect {
            delete :destroy, params: { editable_type: 'Lesson',
                                      lesson_id: lesson.id, id: authorship.id }
          }.to change(Authorship, :count).by(-1)
        end

        it 'destroys the lesson if last author' do
          authorship = lesson.authorships.first
          expect {
            delete :destroy, params: { editable_type: 'Lesson',
                                      lesson_id: lesson.id, id: authorship.id }
          }.to change(Lesson, :count).by(-1)
        end
      end
    end
  end
end
