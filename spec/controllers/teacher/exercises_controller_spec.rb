require 'rails_helper'

RSpec.describe Teacher::ExercisesController, type: :controller do
  let!(:exercise) { create(:exercise) }
  let(:valid_attributes) { attributes_for(:exercise).merge(teaching_id: create(:teaching).id) }

  context 'as a guest' do
    describe 'GET #index' do
      it { expect(get(:index)).to have_http_status(302) }
    end

    describe 'GET #show' do
      it { expect(get(:show, params: { id: exercise.id })).to have_http_status(302) }
    end

    describe 'GET #new' do
      it { expect(get(:new)).to have_http_status(302) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { lesson: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { lesson: valid_attributes }) }.not_to change(Exercise, :count) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: exercise.id })).to have_http_status(302) }
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: exercise.id, exercise: { name: 'foo' } })).to have_http_status(302) }
      it 'does not update the exercise' do
        patch :update, params: { id: exercise.id, exercise: { name: 'foo' } }
        expect(exercise.reload.name).not_to eq('foo')
      end
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: exercise.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: exercise.id }) }.not_to change(Exercise, :count) }
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
      it { expect(get(:show, params: { id: exercise.id })).to have_http_status(302) }
    end

    describe 'GET #new' do
      it { expect(get(:new)).to have_http_status(302) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { lesson: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { lesson: valid_attributes }) }.not_to change(Exercise, :count) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: exercise.id })).to have_http_status(302) }
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: exercise.id, exercise: { name: 'foo' } })).to have_http_status(302) }
      it 'does not update the exercise' do
        patch :update, params: { id: exercise.id, exercise: { name: 'foo' } }
        expect(exercise.reload.name).not_to eq('foo')
      end
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: exercise.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: exercise.id }) }.not_to change(Exercise, :count) }
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
      it { expect(get(:show, params: { id: exercise.id })).to have_http_status(302) }
    end

    describe 'GET #new' do
      it { expect(get(:new)).to have_http_status(302) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { lesson: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { lesson: valid_attributes }) }.not_to change(Exercise, :count) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: exercise.id })).to have_http_status(302) }
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: exercise.id, exercise: { name: 'foo' } })).to have_http_status(302) }
      it 'does not update the exercise' do
        patch :update, params: { id: exercise.id, exercise: { name: 'foo' } }
        expect(exercise.reload.name).not_to eq('foo')
      end
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: exercise.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: exercise.id }) }.not_to change(Exercise, :count) }
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
      it { expect(get(:show, params: { id: exercise.id })).to have_http_status(200) }
    end

    describe 'GET #new' do
      it { expect(get(:new)).to have_http_status(200) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { exercise: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { exercise: valid_attributes }) }.to change(Exercise, :count).by(1) }
      it { expect(post(:create, params: { exercise: { invalid: 'attributes' } })).to have_http_status(200) }
      it { expect { post(:create, params: { exercise: { invalid: 'attributes' } }) }.not_to change(Exercise, :count) }
    end

    describe 'GET #edit' do
      context 'as an author' do
        before { create(:authorship, author: teacher, editable: exercise) }

        it { expect(get(:edit, params: { id: exercise.id })).to have_http_status(200) }
      end

      context 'not an author' do
        it { expect(get(:edit, params: { id: exercise.id })).to have_http_status(302) }
      end
    end

    describe 'PATCH #update' do
      context 'as an author' do
        before { create(:authorship, author: teacher, editable: exercise) }

        it { expect(patch(:update, params: { id: exercise.id, exercise: { name: 'foo' } })).to have_http_status(302) }
        it 'updates the exercise' do
          patch :update, params: { id: exercise.id, exercise: { name: 'foo' } }
          expect(exercise.reload.name).to eq('foo')
        end
        it { expect(patch(:update, params: { id: exercise.id, exercise: { name: '' } })).to have_http_status(200) }
      end
    end

    describe 'DELETE #destroy' do
      context 'as an author' do
        before { create(:authorship, author: teacher, editable: exercise) }

        it { expect(delete(:destroy, params: { id: exercise.id })).to have_http_status(302) }
        it { expect { delete(:destroy, params: { id: exercise.id }) }.to change(Exercise, :count).by(-1) }
      end

      context 'not an author' do
        it { expect(delete(:destroy, params: { id: exercise.id })).to have_http_status(302) }
        it { expect { delete(:destroy, params: { id: exercise.id }) }.not_to change(Exercise, :count) }
      end
    end
  end
end
