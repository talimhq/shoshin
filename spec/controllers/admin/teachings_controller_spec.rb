require 'rails_helper'

RSpec.describe Admin::TeachingsController, type: :controller do
  let!(:teaching) { create(:teaching) }
  let(:valid_attributes) { attributes_for(:teaching).merge(cycle_ids: [create(:cycle).id]) }

  context 'as a  guest' do
    describe 'GET #index' do
      it { expect(get(:index)).to have_http_status(302) }
    end

    describe 'GET #new' do
      it { expect(get(:new)).to have_http_status(302) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: teaching.id })).to have_http_status(302) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { teaching: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { teaching: valid_attributes }) }.not_to change(Teaching, :count) }
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: teaching.id, teaching: valid_attributes })).to have_http_status(302) }
      it { expect { patch(:update, params: { id: teaching.id, teaching: valid_attributes }) }.not_to change(teaching, :name) }
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: teaching.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: teaching.id }) }.not_to change(Teaching, :count) }
    end
  end

  context 'as a user' do
    before do
      sign_in create(:user_account)
    end

    describe 'GET #index' do
      it { expect(get(:index)).to have_http_status(302) }
    end

    describe 'GET #new' do
      it { expect(get(:new)).to have_http_status(302) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: teaching.id })).to have_http_status(302) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { teaching: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { teaching: valid_attributes }) }.not_to change(Teaching, :count) }
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: teaching.id, teaching: valid_attributes })).to have_http_status(302) }
      it { expect { patch(:update, params: { id: teaching.id, teaching: valid_attributes }) }.not_to change(teaching, :name) }
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: teaching.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: teaching.id }) }.not_to change(Teaching, :count) }
    end
  end

  context 'as an admin' do
    before do
      sign_in create(:admin_account)
    end

    describe 'GET #index' do
      it { expect(get(:index)).to have_http_status(200) }
    end

    describe 'GET #new' do
      it { expect(get(:new)).to have_http_status(200) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: teaching.id })).to have_http_status(200) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { teaching: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { teaching: valid_attributes }) }.to change(Teaching, :count).by(1) }
      it { expect(post(:create, params: { teaching: { invalid: 'attributes' } })).to have_http_status(200) }
      it { expect { post(:create, params: { teaching: { invalid: 'attributes' } }) }.not_to change(Teaching, :count) }
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: teaching.id, teaching: valid_attributes })).to have_http_status(302) }
      it 'updates the name' do
        patch :update, params: { id: teaching.id, teaching: { name: 'foo' } }
        expect(teaching.reload.name).to eq('foo')
      end
      it { expect(patch(:update, params: { id: teaching.id, teaching: { name: '' } })).to have_http_status(200) }
      it 'does not update the name' do
        patch :update, params: { id: teaching.id, teaching: { name: '' } }
        expect(teaching.reload.name).not_to eq('')
      end
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: teaching.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: teaching.id }) }.to change(Teaching, :count).by(-1) }
    end
  end
end
