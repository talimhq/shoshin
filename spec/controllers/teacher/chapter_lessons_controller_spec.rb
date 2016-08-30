require 'rails_helper'

RSpec.describe Teacher::ChapterLessonsController, type: :controller do
  let(:chapter) { create(:chapter) }
  let(:lesson) { create(:lesson) }

  before { lesson.update(level_ids: [chapter.group.level_id]) }

  describe 'GET #edit' do
    context 'as a guest' do
      it 'redirects' do
        get :edit, params: { id: chapter.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who does not own the chapter' do
        it 'redirects' do
          get :edit, params: { id: chapter.id }
          expect(response).to have_http_status(302)
        end
      end

      context 'who owns the chapter' do
        before { chapter.update(teacher: teacher) }

        it 'is a success' do
          get :edit, params: { id: chapter.id }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'PATCH #update' do
    context 'as a guest' do
      it 'does not create a new chapter_lesson' do
        expect {
          patch :update, params: { id: chapter.id,
                                   chapter: { lesson_ids: [lesson.id] } }
        }.not_to change(ChapterLesson, :count)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who does not own the chapter nor the lesson' do
        it 'does not create a new chapter_lesson' do
          expect {
            patch :update, params: { id: chapter.id,
                                     chapter: { lesson_ids: [lesson.id] } }
          }.not_to change(ChapterLesson, :count)
        end
      end

      context 'who does not own the chapter but owns the lesson' do
        before { lesson.update(authors: [teacher]) }

        it 'does not create a new chapter_lesson' do
          expect {
            patch :update, params: { id: chapter.id,
                                     chapter: { lesson_ids: [lesson.id] } }
          }.not_to change(ChapterLesson, :count)
        end
      end

      context 'who owns the chapter but not the lesson' do
        before { chapter.update(teacher: teacher) }

        it 'does not create a new chapter_lesson' do
          expect {
            patch :update, params: { id: chapter.id,
                                     chapter: { lesson_ids: [lesson.id] } }
          }.not_to change(ChapterLesson, :count)
        end
      end

      context 'who owns both the chapter and the lesson' do
        before  do
          lesson.update(authors: [teacher])
          chapter.update(teacher: teacher)
        end

        it 'creates a new chapter_lesson' do
          expect {
            patch :update, params: { id: chapter.id,
                                     chapter: { lesson_ids: [lesson.id] } }
          }.to change(ChapterLesson, :count).by(1)
        end

        it 'destroys existing chapter_lessons' do
          create(:chapter_lesson, chapter: chapter, lesson: lesson)
          expect {
            patch :update, params: { id: chapter.id }
          }.to change(ChapterLesson, :count).by(-1)
        end
      end
    end
  end
end
