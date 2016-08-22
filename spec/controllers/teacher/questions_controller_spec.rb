require 'rails_helper'

RSpec.describe Teacher::QuestionsController, type: :controller do
  let!(:question) { create(:question) }
  let(:valid_attributes) { attributes_for(:question) }

  context 'as a guest' do
    describe 'GET #new' do
      it { expect(get(:new, params: { exercise_id: question.exercise_id })).to have_http_status(302) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { exercise_id: question.exercise_id, question: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { exercise_id: question.exercise_id, question: valid_attributes }) }.not_to change(Question, :count) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: question.id })).to have_http_status(302) }
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: question.id, question: { content: 'foo' } })).to have_http_status(302) }
      it 'does not update the question' do
        patch :update, params: { id: question.id, question: { content: 'foo' } }
        expect(question.reload.content).not_to eq('foo')
      end
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: question.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: question.id }) }.not_to change(Question, :count) }
    end
  end

  context 'as a student' do
    before { sign_in create(:student) }

    describe 'GET #new' do
      it { expect(get(:new, params: { exercise_id: question.exercise_id })).to have_http_status(302) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { exercise_id: question.exercise_id, question: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { exercise_id: question.exercise_id, question: valid_attributes }) }.not_to change(Question, :count) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: question.id })).to have_http_status(302) }
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: question.id, question: { content: 'foo' } })).to have_http_status(302) }
      it 'does not update the question' do
        patch :update, params: { id: question.id, question: { content: 'foo' } }
        expect(question.reload.content).not_to eq('foo')
      end
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: question.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: question.id }) }.not_to change(Question, :count) }
    end
  end

  context 'as a parent' do
    before { sign_in create(:parent) }

    describe 'GET #new' do
      it { expect(get(:new, params: { exercise_id: question.exercise_id })).to have_http_status(302) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { exercise_id: question.exercise_id, question: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { exercise_id: question.exercise_id, question: valid_attributes }) }.not_to change(Question, :count) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: question.id })).to have_http_status(302) }
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: question.id, question: { content: 'foo' } })).to have_http_status(302) }
      it 'does not update the question' do
        patch :update, params: { id: question.id, question: { content: 'foo' } }
        expect(question.reload.content).not_to eq('foo')
      end
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: question.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: question.id }) }.not_to change(Question, :count) }
    end
  end

  context 'not an author' do
    before { sign_in create(:teacher) }

    describe 'GET #new' do
      it { expect(get(:new, params: { exercise_id: question.exercise_id })).to have_http_status(302) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { exercise_id: question.exercise_id, question: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { exercise_id: question.exercise_id, question: valid_attributes }) }.not_to change(Question, :count) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: question.id })).to have_http_status(302) }
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: question.id, question: { content: 'foo' } })).to have_http_status(302) }
      it 'does not update the question' do
        patch :update, params: { id: question.id, question: { content: 'foo' } }
        expect(question.reload.content).not_to eq('foo')
      end
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: question.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: question.id }) }.not_to change(Question, :count) }
    end
  end

  context 'as an author' do
    before { sign_in teacher }
    before { question.exercise.update(authors: [teacher]) }

    let(:teacher) { create(:teacher) }

    describe 'GET #new' do
      it { expect(get(:new, params: { exercise_id: question.exercise_id })).to have_http_status(200) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { exercise_id: question.exercise_id, question: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { exercise_id: question.exercise_id, question: valid_attributes }) }.to change(Question, :count).by(1) }
      it 'updates the cache counter' do
        post :create, params: { exercise_id: question.exercise_id, question: valid_attributes }
        expect(question.reload.exercise.questions_count).to eq(2)
      end
      it { expect(post(:create, params: { exercise_id: question.exercise_id, question: { invalid: 'attributes' } })).to have_http_status(200) }
      it { expect { post(:create, params: { exercise_id: question.exercise_id, question: { invalid: 'attributes' } }) }.not_to change(Question, :count) }
      it 'does not update the cache counter' do
        post :create, params: { exercise_id: question.exercise_id, question: { invalid: 'attributes' } }
        expect(question.reload.exercise.questions_count).to eq(1)
      end
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: question.id })).to have_http_status(200) }
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: question.id, question: { content: 'foo' } })).to have_http_status(302) }
      it 'updates the question' do
        patch :update, params: { id: question.id, question: { content: 'foo' } }
        expect(question.reload.content).to eq('foo')
      end
      it { expect(patch(:update, params: { id: question.id, question: { content: '' } })).to have_http_status(200) }
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: question.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: question.id }) }.to change(Question, :count).by(-1) }
      it 'updates the cache counter' do
        delete :destroy, params: { id: question.id }
        expect(question.exercise.reload.questions_count).to eq(0)
      end
    end
  end
end
