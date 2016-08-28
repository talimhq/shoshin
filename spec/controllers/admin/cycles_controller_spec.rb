require 'rails_helper'

RSpec.describe Admin::CyclesController, type: :controller do
  let!(:cycle) { create(:cycle, position: 1) }
  let!(:level) { create(:level, cycle: cycle) }
  let(:cycle2) { create(:cycle, position: 2) }
  let(:valid_attributes) {
    {
      name: Faker::Company.name,
      levels_attributes: [attributes_for(:level)]
    }
  }

  context 'as a  guest' do
    describe 'GET #index' do
      it { expect(get(:index)).to have_http_status(302) }
    end

    describe 'GET #new' do
      it { expect(get(:new)).to have_http_status(302) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: cycle.id })).to have_http_status(302) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { cycle: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { cycle: valid_attributes }) }.not_to change(Cycle, :count) }
    end

    describe 'POST #sort' do
      it { expect(post(:sort, params: { cycle: [cycle2.id, cycle.id] })).to have_http_status(302) }
      it 'does not change cycles position' do
        post(:sort, params: { cycle: [cycle2.id, cycle.id] })
        expect(Cycle.ordered).to eq([cycle, cycle2])
      end
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: cycle.id, cycle: valid_attributes })).to have_http_status(302) }
      it { expect { patch(:update, params: { id: cycle.id, cycle: valid_attributes }) }.not_to change(cycle, :name) }
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: cycle.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: cycle.id }) }.not_to change(Cycle, :count) }
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
      it { expect(get(:edit, params: { id: cycle.id })).to have_http_status(302) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { cycle: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { cycle: valid_attributes }) }.not_to change(Cycle, :count) }
    end

    describe 'POST #sort' do
      it { expect(post(:sort, params: { cycle: [cycle2.id, cycle.id] })).to have_http_status(302) }
      it 'does not change cycles position' do
        post(:sort, params: { cycle: [cycle2.id, cycle.id] })
        expect(Cycle.ordered).to eq([cycle, cycle2])
      end
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: cycle.id, cycle: valid_attributes })).to have_http_status(302) }
      it { expect { patch(:update, params: { id: cycle.id, cycle: valid_attributes }) }.not_to change(cycle, :name) }
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: cycle.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: cycle.id }) }.not_to change(Cycle, :count) }
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
      it { expect(get(:edit, params: { id: cycle.id })).to have_http_status(200) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { cycle: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { cycle: valid_attributes }) }.to change(Cycle, :count).by(1) }
      it { expect { post(:create, params: { cycle: valid_attributes }) }.to change(Level, :count).by(1) }
      it { expect(post(:create, params: { cycle: { invalid: 'attributes' } })).to have_http_status(200) }
      it { expect { post(:create, params: { cycle: { invalid: 'attributes' } }) }.not_to change(Cycle, :count) }
    end

    describe 'POST #sort' do
      it { expect(post(:sort, params: { cycle: [cycle2.id, cycle.id] })).to have_http_status(200) }
      it 'does change cycles position' do
        post(:sort, params: { cycle: [cycle2.id, cycle.id] })
        expect(Cycle.ordered).to eq([cycle2, cycle])
      end
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: cycle.id, cycle: valid_attributes })).to have_http_status(302) }
      it 'updates the cycle' do
        patch :update, params: { id: cycle.id, cycle: { name: 'foo' } }
        expect(cycle.reload.name).to eq('foo')
      end
      it { expect(patch(:update, params: { id: cycle.id, cycle: { name: ' ' } })).to have_http_status(200) }
      it { expect { patch(:update, params: { id: cycle.id, cycle: { name: ' ' } }) }.not_to change(cycle, :name) }
      it { expect { patch(:update, params: { id: cycle.id, cycle: { levels_attributes: { '0' => { id: level.id, _destroy: true } } } }) }.to change(Level, :count).by(-1) }
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: cycle.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: cycle.id }) }.to change(Cycle, :count).by(-1) }
      it { expect { delete(:destroy, params: { id: cycle.id }) }.to change(Level, :count).by(-1) }
    end
  end
end
