require 'rails_helper'

RSpec.describe Teacher::SharedLessonsController, type: :controller do
  let!(:lesson) { create(:lesson) }
  let(:secret_lesson) { create(:lesson, shared: false) }

  context 'as a guest' do
    it { expect(get(:index)).to have_http_status(302) }
    it { expect(post(:create, params: { lesson_id: lesson.id })).to have_http_status(302) }
    it { expect { post(:create, params: { lesson_id: lesson.id }) }.not_to change(Lesson, :count) }
  end

  context 'as a student' do
    before { sign_in create(:student) }
    it { expect(get(:index)).to have_http_status(302) }
    it { expect(post(:create, params: { lesson_id: lesson.id })).to have_http_status(302) }
    it { expect { post(:create, params: { lesson_id: lesson.id }) }.not_to change(Lesson, :count) }
  end

  context 'as a parent' do
    before { sign_in create(:parent) }
    it { expect(get(:index)).to have_http_status(302) }
    it { expect(post(:create, params: { lesson_id: lesson.id })).to have_http_status(302) }
    it { expect { post(:create, params: { lesson_id: lesson.id }) }.not_to change(Lesson, :count) }
  end

  context 'as a teacher' do
    before { sign_in create(:teacher) }
    it { expect(get(:index)).to have_http_status(200) }
    it { expect(post(:create, params: { lesson_id: lesson.id })).to have_http_status(302) }
    it { expect { post(:create, params: { lesson_id: lesson.id }) }.to change(Lesson, :count).by(1) }
    it 'increase popularity' do
      post :create, params: { lesson_id: lesson.id }
      expect(lesson.reload.popularity).to eq(1)
    end
  end
end
