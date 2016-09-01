require 'rails_helper'

RSpec.describe Student::ChapterLessonsController, type: :controller do
  let(:chapter_lesson) { create(:chapter_lesson) }
  let(:chapter) { chapter_lesson.chapter }
  let(:lesson) { chapter_lesson.lesson }

  describe 'GET #show' do
    context 'as a guest' do
      it 'redirects' do
        get :show, params: { chapter_id: chapter.id, id: lesson.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a student' do
      let(:student) { create(:student) }
      before { sign_in student.account }

      it 'redirects if student does not belong in the group' do
        get :show, params: { chapter_id: chapter.id, id: lesson.id }
        expect(response).to have_http_status(302)
      end

      it 'is a success if student belongs in the group' do
        chapter.group.update(students: [student])
        get :show, params: { chapter_id: chapter.id, id: lesson.id }
        expect(response).to have_http_status(200)
      end
    end
  end
end
