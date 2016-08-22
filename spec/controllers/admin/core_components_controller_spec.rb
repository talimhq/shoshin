require 'rails_helper'

RSpec.describe Admin::CoreComponentsController, type: :controller do
  let!(:core_component) { create(:core_component) }
  let(:valid_attributes) { attributes_for(:core_component) }

  context 'as a  guest' do
    describe 'GET #index' do
      it { expect(get(:index)).to have_http_status(302) }
    end

    describe 'GET #new' do
      it { expect(get(:new)).to have_http_status(302) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: core_component.id })).to have_http_status(302) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { core_component: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { core_component: valid_attributes }) }.not_to change(CoreComponent, :count) }
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: core_component.id, core_component: valid_attributes })).to have_http_status(302) }
      it { expect { patch(:update, params: { id: core_component.id, core_component: valid_attributes }) }.not_to change(core_component, :name) }
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: core_component.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: core_component.id }) }.not_to change(CoreComponent, :count) }
    end
  end

  context 'as a user' do
    before do
      sign_in create(:user)
    end

    describe 'GET #index' do
      it { expect(get(:index)).to have_http_status(302) }
    end

    describe 'GET #new' do
      it { expect(get(:new)).to have_http_status(302) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: core_component.id })).to have_http_status(302) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { core_component: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { core_component: valid_attributes }) }.not_to change(CoreComponent, :count) }
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: core_component.id, core_component: valid_attributes })).to have_http_status(302) }
      it { expect { patch(:update, params: { id: core_component.id, core_component: valid_attributes }) }.not_to change(core_component, :name) }
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: core_component.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: core_component.id }) }.not_to change(CoreComponent, :count) }
    end
  end

  context 'as an admin' do
    before do
      sign_in create(:admin)
    end

    describe 'GET #index' do
      it { expect(get(:index)).to have_http_status(200) }
    end

    describe 'GET #new' do
      it { expect(get(:new)).to have_http_status(200) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: core_component.id })).to have_http_status(200) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { core_component: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { core_component: valid_attributes }) }.to change(CoreComponent, :count).by(1) }
      it { expect(post(:create, params: { core_component: { invalid: 'attributes' } })).to have_http_status(200) }
      it { expect { post(:create, params: { core_component: { invalid: 'attributes' } }) }.not_to change(CoreComponent, :count) }
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: core_component.id, core_component: valid_attributes })).to have_http_status(302) }
      it 'updates the core_component' do
        patch :update, params: { id: core_component.id, core_component: { name: 'foo' } }
        expect(core_component.reload.name).to eq('foo')
      end
      it { expect(patch(:update, params: { id: core_component.id, core_component: { name: ' ' } })).to have_http_status(200) }
      it { expect { patch(:update, params: { id: core_component.id, core_component: { name: ' ' } }) }.not_to change(core_component, :name) }
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: core_component.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: core_component.id }) }.to change(CoreComponent, :count).by(-1) }
    end
  end
end
