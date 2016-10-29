require 'rails_helper'

RSpec.describe Teacher::LessonChaptersController, type: :controller do
  let(:lesson) { create(:lesson) }

  describe 'GET #new' do
    context 'as a guest' do
      it 'redirects' do
        get :new, params: { lesson_id: lesson.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who is not an author' do
        it 'redirects' do
          get :new, params: { lesson_id: lesson.id }
          expect(response).to have_http_status(302)
        end
      end

      context 'who is an author' do
        it 'is a success' do
          lesson.update(authors: [teacher])
          get :new, params: { lesson_id: lesson.id }
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
      it 'does not create the chapter_lesson' do
        expect {
          post :create, params: { lesson_id: lesson.id,
                                  chapter_lesson: { chapter_id: chapter.id } }
        }.not_to change(ChapterLesson, :count)
      end
    end

    context 'who does not own the chapter' do
      it 'does not create the chapter_lesson' do
        lesson.update(authors: [teacher])
        expect {
          post :create, params: { lesson_id: lesson.id,
                                  chapter_lesson: { chapter_id: chapter.id } }
        }.not_to change(ChapterLesson, :count)
      end
    end

    context 'who owns the chapter' do
      context 'with valid attributes' do
        it 'creates the chapter_lesson' do
          lesson.update(authors: [teacher])
          chapter.update(teacher: teacher)
          expect {
            post :create, params: { lesson_id: lesson.id,
                                    chapter_lesson: { chapter_id: chapter.id } }
          }.to change(ChapterLesson, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not create duplicate chapter_lesson' do
          lesson.update(authors: [teacher])
          chapter.update(teacher: teacher)
          ChapterLesson.create(lesson: lesson, chapter: chapter)
          expect {
            post :create, params: { lesson_id: lesson.id,
                                    chapter_lesson: { chapter_id: chapter.id } }
          }.not_to change(ChapterLesson, :count)
        end
      end
    end
  end
end
