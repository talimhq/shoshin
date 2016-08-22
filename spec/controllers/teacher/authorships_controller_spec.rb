require 'rails_helper'

RSpec.describe Teacher::AuthorshipsController, type: :controller do
  let(:new_author) { create(:user) }
  let!(:authorship) { create(:authorship) }
  let(:author) { authorship.author }
  let(:lesson) { authorship.editable }

  context 'as a guest' do
    it { expect(get(:index, params: { editable_type: 'Lesson', lesson_id: lesson.id })).to have_http_status(302) }
    it { expect(get(:new, params: { editable_type: 'Lesson', lesson_id: lesson.id })).to have_http_status(302) }
    it { expect(post(:create, params: { editable_type: 'Lesson', lesson_id: lesson.id, authorship: { author_id: new_author.id } })).to have_http_status(302) }
    it {
      post :create, params: { editable_type: 'Lesson', lesson_id: lesson.id, authorship: { author_id: new_author.id } }
      expect(lesson.reload.authorships.size).to eq(1)
    }
    it { expect(delete(:destroy, params: { editable_type: 'Lesson', lesson_id: lesson.id, id: authorship.id })).to have_http_status(302) }
    it {
      delete :destroy, params: { editable_type: 'Lesson', lesson_id: lesson.id, id: authorship.id }
      expect(lesson.reload.authorships.size).to eq(1)
    }
  end

  context 'as a student' do
    before { sign_in create(:student) }
    it { expect(get(:index, params: { editable_type: 'Lesson', lesson_id: lesson.id })).to have_http_status(302) }
    it { expect(get(:new, params: { editable_type: 'Lesson', lesson_id: lesson.id })).to have_http_status(302) }
    it { expect(post(:create, params: { editable_type: 'Lesson', lesson_id: lesson.id, authorship: { author_id: new_author.id } })).to have_http_status(302) }
    it {
      post :create, params: { editable_type: 'Lesson', lesson_id: lesson.id, authorship: { author_id: new_author.id } }
      expect(lesson.reload.authorships.size).to eq(1)
    }
    it { expect(delete(:destroy, params: { editable_type: 'Lesson', lesson_id: lesson.id, id: authorship.id })).to have_http_status(302) }
    it {
      delete :destroy, params: { editable_type: 'Lesson', lesson_id: lesson.id, id: authorship.id }
      expect(lesson.reload.authorships.size).to eq(1)
    }
  end

  context 'as a parent' do
    before { sign_in create(:parent) }
    it { expect(get(:index, params: { editable_type: 'Lesson', lesson_id: lesson.id })).to have_http_status(302) }
    it { expect(get(:new, params: { editable_type: 'Lesson', lesson_id: lesson.id })).to have_http_status(302) }
    it { expect(post(:create, params: { editable_type: 'Lesson', lesson_id: lesson.id, authorship: { author_id: new_author.id } })).to have_http_status(302) }
    it {
      post :create, params: { editable_type: 'Lesson', lesson_id: lesson.id, authorship: { author_id: new_author.id } }
      expect(lesson.reload.authorships.size).to eq(1)
    }
    it { expect(delete(:destroy, params: { editable_type: 'Lesson', lesson_id: lesson.id, id: authorship.id })).to have_http_status(302) }
    it {
      delete :destroy, params: { editable_type: 'Lesson', lesson_id: lesson.id, id: authorship.id }
      expect(lesson.reload.authorships.size).to eq(1)
    }
  end

  context 'as a teacher' do
    before { sign_in create(:teacher) }
    it { expect(get(:index, params: { editable_type: 'Lesson', lesson_id: lesson.id })).to have_http_status(302) }
    it { expect(get(:new, params: { editable_type: 'Lesson', lesson_id: lesson.id })).to have_http_status(302) }
    it { expect(post(:create, params: { editable_type: 'Lesson', lesson_id: lesson.id, authorship: { author_id: new_author.id } })).to have_http_status(302) }
    it {
      post :create, params: { editable_type: 'Lesson', lesson_id: lesson.id, authorship: { author_id: new_author.id } }
      expect(lesson.reload.authorships.size).to eq(1)
    }
    it { expect(delete(:destroy, params: { editable_type: 'Lesson', lesson_id: lesson.id, id: authorship.id })).to have_http_status(302) }
    it {
      delete :destroy, params: { editable_type: 'Lesson', lesson_id: lesson.id, id: authorship.id }
      expect(lesson.reload.authorships.size).to eq(1)
    }
  end

  context 'as an author' do
    before { sign_in author }
    it { expect(get(:index, params: { editable_type: 'Lesson', lesson_id: lesson.id })).to have_http_status(200) }
    it { expect(get(:new, params: { editable_type: 'Lesson', lesson_id: lesson.id })).to have_http_status(200) }
    it { expect(post(:create, params: { editable_type: 'Lesson', lesson_id: lesson.id, authorship: { author_id: new_author.id } })).to have_http_status(200) }
    it {
      post :create, params: { editable_type: 'Lesson', lesson_id: lesson.id, authorship: { author_id: new_author.id } }
      expect(lesson.reload.authorships.size).to eq(2)
    }
    context 'last author' do
      it { expect(delete(:destroy, params: { editable_type: 'Lesson', lesson_id: lesson.id, id: authorship.id })).to have_http_status(302) }
      it {
        delete :destroy, params: { editable_type: 'Lesson', lesson_id: lesson.id, id: authorship.id }
        expect(Authorship.count).to eq(0)
      }
      it {
        delete :destroy, params: { editable_type: 'Lesson', lesson_id: lesson.id, id: authorship.id }
        expect(Lesson.count).to eq(0)
      }
    end

    context 'not last author' do
      before { new_author.update(lessons: [lesson]) }
      it { expect(delete(:destroy, params: { editable_type: 'Lesson', lesson_id: lesson.id, id: authorship.id })).to have_http_status(302) }
      it {
        delete :destroy, params: { editable_type: 'Lesson', lesson_id: lesson.id, id: authorship.id }
        expect(lesson.reload.authorships.size).to eq(1)
      }
      it {
        delete :destroy, params: { editable_type: 'Lesson', lesson_id: lesson.id, id: authorship.id }
        expect(Lesson.count).to eq(1)
      }
    end
  end
end
