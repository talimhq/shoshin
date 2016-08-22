require 'rails_helper'

RSpec.describe Teacher::AnswersController, type: :controller do
  let(:question) { create(:question) }

  context 'as a guest' do
    it { expect(get(:index, params: { id: question.id })).to have_http_status(302) }
  end

  context 'as a student' do
    before { sign_in create(:student) }
    it { expect(get(:index, params: { id: question.id })).to have_http_status(302) }
  end

  context 'as a parent' do
    before { sign_in create(:parent) }
    it { expect(get(:index, params: { id: question.id })).to have_http_status(302) }
  end

  context 'as an unauthorized teacher' do
    before { sign_in create(:teacher) }
    it { expect(get(:index, params: { id: question.id })).to have_http_status(302) }
  end

  context 'as an author' do
    let(:author) { create(:teacher) }
    before do
      question.exercise.update(authors: [author])
      sign_in author
    end

    describe 'GET #index' do
      it { expect(get(:index, params: { id: question.id })).to have_http_status(200) }
    end

    describe 'PATCH #update' do
      context 'input question' do
        let(:question) { create(:input_question) }
        let!(:answer) { create(:answers_input, question: question.becomes(Questions::Input)) }
        let(:valid_attributes) { { answers_attributes: { '0' => attributes_for(:answers_input) } } }

        it { expect(patch(:update, params: { id: question.id, questions_input: valid_attributes })).to have_http_status(302) }
        it { expect { patch(:update, params: { id: question.id, questions_input: valid_attributes }) }.to change(Answers::Input, :count).by(1) }

        it 'destroys answers' do
          expect {
            patch :update, params: { id: question.id, questions_input: { answers_attributes: { '0' => { _destroy: '1', id: answer.id } } } }
          }.to change(Answers::Input, :count).by(-1)
        end

        it 'updates answer' do
          patch :update, params: { id: question.id, questions_input: { answers_attributes: { '0' => { content: 'foo', id: answer.id } } } }
          expect(question.becomes(Questions::Input).reload.answers.first.content).to eq('foo')
        end
      end

      context 'single_choice question' do
        let(:question) { create(:single_choice_question).becomes(Questions::SingleChoice) }
        let(:valid_attributes) { { answers_attributes: { '0' => attributes_for(:answers_single_choice, correct: true) } } }
        let(:invalid_attributes) { { answers_attributes: { '0' => attributes_for(:answers_single_choice, correct: false) } } }

        it { expect(patch(:update, params: { id: question.id, questions_single_choice: valid_attributes })).to have_http_status(302) }
        it { expect { patch(:update, params: { id: question.id, questions_single_choice: valid_attributes }) }.to change(Answers::SingleChoice, :count).by(1) }
        it { expect(patch(:update, params: { id: question.id, questions_single_choice: invalid_attributes })).to have_http_status(200) }
        it { expect { patch(:update, params: { id: question.id, questions_single_choice: invalid_attributes }) }.not_to change(Answers::SingleChoice, :count) }

        it 'destroys answers' do
          answer = create(:answers_single_choice, question: question, correct: true)
          expect {
            patch :update, params: { id: question.id, questions_single_choice: { answers_attributes: { '0' => { _destroy: '1', id: answer.id } } } }
          }.to change(Answers::SingleChoice, :count).by(-1)
        end

        it 'updates answer' do
          answer = create(:answers_single_choice, question: question, correct: true)
          patch :update, params: { id: question.id, questions_single_choice: { answers_attributes: { '0' => { content: 'foo', id: answer.id } } } }
          expect(question.becomes(Questions::SingleChoice).reload.answers.first.content).to eq('foo')
        end
      end

      context 'multiple_choice question' do
        let(:question) { create(:multiple_choice_question).becomes(Questions::MultipleChoice) }
        let(:valid_attributes) { { answers_attributes: { '0' => attributes_for(:answers_multiple_choice, correct: true) } } }
        let(:invalid_attributes) { { answers_attributes: { '0' => attributes_for(:answers_multiple_choice, correct: false) } } }

        it { expect(patch(:update, params: { id: question.id, questions_multiple_choice: valid_attributes })).to have_http_status(302) }
        it { expect { patch(:update, params: { id: question.id, questions_multiple_choice: valid_attributes }) }.to change(Answers::MultipleChoice, :count).by(1) }
        it { expect(patch(:update, params: { id: question.id, questions_multiple_choice: invalid_attributes })).to have_http_status(200) }
        it { expect { patch(:update, params: { id: question.id, questions_multiple_choice: invalid_attributes }) }.not_to change(Answers::MultipleChoice, :count) }

        it 'destroys answers' do
          answer = create(:answers_multiple_choice, question: question, correct: true)
          expect {
            patch :update, params: { id: question.id, questions_multiple_choice: { answers_attributes: { '0' => { _destroy: '1', id: answer.id } } } }
          }.to change(Answers::MultipleChoice, :count).by(-1)
        end

        it 'updates answer' do
          answer = create(:answers_multiple_choice, question: question, correct: true)
          patch :update, params: { id: question.id, questions_multiple_choice: { answers_attributes: { '0' => { content: 'foo', id: answer.id } } } }
          expect(question.becomes(Questions::MultipleChoice).reload.answers.first.content).to eq('foo')
        end
      end

      context 'classify question' do
        let(:question) { create(:classify_question) }
        let!(:answer) { create(:answers_category, question: question.becomes(Questions::Classify)) }
        let(:valid_attributes) { { answers_attributes: { '0' => attributes_for(:answers_category) } } }

        it { expect(patch(:update, params: { id: question.id, questions_classify: valid_attributes })).to have_http_status(302) }
        it { expect { patch(:update, params: { id: question.id, questions_classify: valid_attributes }) }.to change(Answers::Category, :count).by(1) }

        it 'destroys answers' do
          expect {
            patch :update, params: { id: question.id, questions_classify: { answers_attributes: { '0' => { _destroy: '1', id: answer.id } } } }
          }.to change(Answers::Category, :count).by(-1)
        end

        it 'updates answer' do
          patch :update, params: { id: question.id, questions_classify: { answers_attributes: { '0' => { name: 'foo', id: answer.id } } } }
          expect(question.becomes(Questions::Classify).reload.answers.first.name).to eq('foo')
        end
      end

      context 'association question' do
        let(:question) { create(:association_question) }
        let!(:answer) { create(:answers_association, question: question.becomes(Questions::Association)) }
        let(:valid_attributes) { { answers_attributes: { '0' => attributes_for(:answers_association) } } }

        it { expect(patch(:update, params: { id: question.id, questions_association: valid_attributes })).to have_http_status(302) }
        it { expect { patch(:update, params: { id: question.id, questions_association: valid_attributes }) }.to change(Answers::Association, :count).by(1) }

        it 'destroys answers' do
          expect {
            patch :update, params: { id: question.id, questions_association: { answers_attributes: { '0' => { _destroy: '1', id: answer.id } } } }
          }.to change(Answers::Association, :count).by(-1)
        end

        it 'updates answer' do
          patch :update, params: { id: question.id, questions_association: { answers_attributes: { '0' => { right: 'foo', id: answer.id } } } }
          expect(question.becomes(Questions::Association).reload.answers.first.right).to eq('foo')
        end
      end
    end
  end
end
