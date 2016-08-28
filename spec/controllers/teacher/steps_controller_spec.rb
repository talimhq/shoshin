require 'rails_helper'

RSpec.describe Teacher::StepsController, type: :controller do
  let!(:step) { create(:step) }
  let(:valid_attributes) { attributes_for(:step) }
  # let(:lesson) { step.lesson }

  context 'as a guest' do
    describe 'GET #new' do
      it { expect(get(:new, params: { lesson_id: step.lesson_id })).to have_http_status(302) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { lesson_id: step.lesson_id, step: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { lesson_id: step.lesson_id, step: valid_attributes }) }.not_to change(Step, :count) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: step.id })).to have_http_status(302) }
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: step.id, step: { content: 'foo' } })).to have_http_status(302) }
      it 'does not update the step' do
        patch :update, params: { id: step.id, step: { content: 'foo' } }
        expect(step.reload.content).not_to eq('foo')
      end
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: step.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: step.id }) }.not_to change(Step, :count) }
    end
  end

  context 'as a student' do
    before { sign_in create(:student_account) }

    describe 'GET #new' do
      it { expect(get(:new, params: { lesson_id: step.lesson_id })).to have_http_status(302) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { lesson_id: step.lesson_id, step: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { lesson_id: step.lesson_id, step: valid_attributes }) }.not_to change(Step, :count) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: step.id })).to have_http_status(302) }
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: step.id, step: { content: 'foo' } })).to have_http_status(302) }
      it 'does not update the step' do
        patch :update, params: { id: step.id, step: { content: 'foo' } }
        expect(step.reload.content).not_to eq('foo')
      end
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: step.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: step.id }) }.not_to change(Step, :count) }
    end
  end

  context 'as a parent' do
    before { sign_in create(:parent_account) }

    describe 'GET #new' do
      it { expect(get(:new, params: { lesson_id: step.lesson_id })).to have_http_status(302) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { lesson_id: step.lesson_id, step: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { lesson_id: step.lesson_id, step: valid_attributes }) }.not_to change(Step, :count) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: step.id })).to have_http_status(302) }
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: step.id, step: { content: 'foo' } })).to have_http_status(302) }
      it 'does not update the step' do
        patch :update, params: { id: step.id, step: { content: 'foo' } }
        expect(step.reload.content).not_to eq('foo')
      end
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: step.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: step.id }) }.not_to change(Step, :count) }
    end
  end

  context 'not an author' do
    let(:teacher) { create(:teacher) }
    before { sign_in teacher.account }

    describe 'GET #new' do
      it { expect(get(:new, params: { lesson_id: step.lesson_id })).to have_http_status(302) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { lesson_id: step.lesson_id, step: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { lesson_id: step.lesson_id, step: valid_attributes }) }.not_to change(Step, :count) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: step.id })).to have_http_status(302) }
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: step.id, step: { content: 'foo' } })).to have_http_status(302) }
      it 'does not update the step' do
        patch :update, params: { id: step.id, step: { content: 'foo' } }
        expect(step.reload.content).not_to eq('foo')
      end
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: step.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: step.id }) }.not_to change(Step, :count) }
    end
  end

  context 'as an author' do
    let(:teacher) { create(:teacher) }
    before { sign_in teacher.account }
    before { step.lesson.update(authors: [teacher]) }

    describe 'GET #new' do
      it { expect(get(:new, params: { lesson_id: step.lesson_id })).to have_http_status(200) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { lesson_id: step.lesson_id, step: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { lesson_id: step.lesson_id, step: valid_attributes }) }.to change(Step, :count).by(1) }
      it 'updates the cache counter' do
        post :create, params: { lesson_id: step.lesson_id, step: valid_attributes }
        expect(step.reload.lesson.steps_count).to eq(2)
      end
      it { expect(post(:create, params: { lesson_id: step.lesson_id, step: { invalid: 'attributes' } })).to have_http_status(200) }
      it { expect { post(:create, params: { lesson_id: step.lesson_id, step: { invalid: 'attributes' } }) }.not_to change(Step, :count) }
      it 'does not update the cache counter' do
        post :create, params: { lesson_id: step.lesson_id, step: { invalid: 'attributes' } }
        expect(step.reload.lesson.steps_count).to eq(1)
      end
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: step.id })).to have_http_status(200) }
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: step.id, step: { content: 'foo' } })).to have_http_status(302) }
      it 'updates the step' do
        patch :update, params: { id: step.id, step: { content: 'foo' } }
        expect(step.reload.content).to eq('foo')
      end
      it { expect(patch(:update, params: { id: step.id, step: { content: '' } })).to have_http_status(200) }
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: step.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: step.id }) }.to change(Step, :count).by(-1) }
      it 'updates the cache counter' do
        delete :destroy, params: { id: step.id }
        expect(step.lesson.reload.steps_count).to eq(0)
      end
    end
  end
end
