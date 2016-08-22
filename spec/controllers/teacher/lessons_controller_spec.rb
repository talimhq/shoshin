require 'rails_helper'

RSpec.describe Teacher::LessonsController, type: :controller do
  let!(:lesson) { create(:lesson) }
  let(:valid_attributes) { attributes_for(:lesson).merge(teaching_id: create(:teaching).id) }

  context 'as a guest' do
    describe 'GET #index' do
      it { expect(get(:index)).to have_http_status(302) }
    end

    describe 'GET #show' do
      it { expect(get(:show, params: { id: lesson.id })).to have_http_status(302) }
    end

    describe 'GET #new' do
      it { expect(get(:new)).to have_http_status(302) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { lesson: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { lesson: valid_attributes }) }.not_to change(Lesson, :count) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: lesson.id })).to have_http_status(302) }
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: lesson.id, lesson: { name: 'foo' } })).to have_http_status(302) }
      it 'does not update the lesson' do
        patch :update, params: { id: lesson.id, lesson: { name: 'foo' } }
        expect(lesson.reload.name).not_to eq('foo')
      end
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: lesson.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: lesson.id }) }.not_to change(Lesson, :count) }
    end
  end

  context 'as a student' do
    before(:each) do
      sign_in create(:student)
    end

    describe 'GET #index' do
      it { expect(get(:index)).to have_http_status(302) }
    end

    describe 'GET #show' do
      it { expect(get(:show, params: { id: lesson.id })).to have_http_status(302) }
    end

    describe 'GET #new' do
      it { expect(get(:new)).to have_http_status(302) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { lesson: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { lesson: valid_attributes }) }.not_to change(Lesson, :count) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: lesson.id })).to have_http_status(302) }
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: lesson.id, lesson: { name: 'foo' } })).to have_http_status(302) }
      it 'does not update the lesson' do
        patch :update, params: { id: lesson.id, lesson: { name: 'foo' } }
        expect(lesson.reload.name).not_to eq('foo')
      end
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: lesson.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: lesson.id }) }.not_to change(Lesson, :count) }
    end
  end

  context 'as a parent' do
    before(:each) do
      sign_in create(:parent)
    end

    describe 'GET #index' do
      it { expect(get(:index)).to have_http_status(302) }
    end

    describe 'GET #show' do
      it { expect(get(:show, params: { id: lesson.id })).to have_http_status(302) }
    end

    describe 'GET #new' do
      it { expect(get(:new)).to have_http_status(302) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { lesson: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { lesson: valid_attributes }) }.not_to change(Lesson, :count) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: lesson.id })).to have_http_status(302) }
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: lesson.id, lesson: { name: 'foo' } })).to have_http_status(302) }
      it 'does not update the lesson' do
        patch :update, params: { id: lesson.id, lesson: { name: 'foo' } }
        expect(lesson.reload.name).not_to eq('foo')
      end
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: lesson.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: lesson.id }) }.not_to change(Lesson, :count) }
    end
  end

  context 'as a teacher' do
    before(:each) do
      sign_in teacher
    end

    let(:teacher) { create(:teacher) }

    describe 'GET #index' do
      it { expect(get(:index)).to have_http_status(200) }
    end

    describe 'GET #show' do
      it { expect(get(:show, params: { id: lesson.id })).to have_http_status(200) }
    end

    describe 'GET #new' do
      it { expect(get(:new)).to have_http_status(200) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { lesson: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { lesson: valid_attributes }) }.to change(Lesson, :count).by(1) }
      it { expect(post(:create, params: { lesson: { invalid: 'attributes' } })).to have_http_status(200) }
      it { expect { post(:create, params: { lesson: { invalid: 'attributes' } }) }.not_to change(Lesson, :count) }
    end

    describe 'GET #edit' do
      context 'as an author' do
        before { create(:authorship, author: teacher, editable: lesson) }

        it { expect(get(:edit, params: { id: lesson.id })).to have_http_status(200) }
      end

      context 'not an author' do
        it { expect(get(:edit, params: { id: lesson.id })).to have_http_status(302) }
      end
    end

    describe 'PATCH #update' do
      context 'as an author' do
        before { create(:authorship, author: teacher, editable: lesson) }

        it { expect(patch(:update, params: { id: lesson.id, lesson: { name: 'foo' } })).to have_http_status(302) }
        it 'updates the lesson' do
          patch :update, params: { id: lesson.id, lesson: { name: 'foo' } }
          expect(lesson.reload.name).to eq('foo')
        end
        it { expect(patch(:update, params: { id: lesson.id, lesson: { name: '' } })).to have_http_status(200) }
      end
    end

    describe 'DELETE #destroy' do
      context 'as an author' do
        before { create(:authorship, author: teacher, editable: lesson) }

        it { expect(delete(:destroy, params: { id: lesson.id })).to have_http_status(302) }
        it { expect { delete(:destroy, params: { id: lesson.id }) }.to change(Lesson, :count).by(-1) }
      end

      context 'not an author' do
        it { expect(delete(:destroy, params: { id: lesson.id })).to have_http_status(302) }
        it { expect { delete(:destroy, params: { id: lesson.id }) }.not_to change(Lesson, :count) }
      end
    end
  end
end
