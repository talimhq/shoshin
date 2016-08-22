require 'rails_helper'

RSpec.describe Admin::AbilitySetsController, type: :controller do
  let!(:ability_set) { create(:ability_set, position: 1) }
  let(:ability_set2) { create(:ability_set, position: 2) }
  let!(:ability_item) { create(:ability_item, ability_set: ability_set) }
  let(:teaching_cycle) { ability_set.teaching_cycle }
  let(:valid_attributes) {
    {
      name: Faker::Company.name,
      ability_items_attributes: [attributes_for(:ability_item)]
    }
  }

  context 'as a  guest' do
    describe 'GET #new' do
      it { expect(get(:new, params: { teaching_cycle_id: ability_set.teaching_cycle_id })).to have_http_status(302) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: ability_set.id })).to have_http_status(302) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { teaching_cycle_id: ability_set.teaching_cycle_id, ability_set: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { teaching_cycle_id: ability_set.teaching_cycle_id, ability_set: valid_attributes }) }.not_to change(AbilitySet, :count) }
    end

    describe 'POST #sort' do
      it { expect(post(:sort, params: { teaching_cycle_id: ability_set.teaching_cycle_id, ability_set: [ability_set2.id, ability_set.id] })).to have_http_status(302) }
      it 'does not change ability_sets position' do
        post(:sort, params: { teaching_cycle_id: ability_set.teaching_cycle_id, ability_set: [ability_set2.id, ability_set.id] })
        expect(AbilitySet.ordered).to eq([ability_set, ability_set2])
      end
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: ability_set.id, ability_set: valid_attributes })).to have_http_status(302) }
      it { expect { patch(:update, params: { id: ability_set.id, ability_set: valid_attributes }) }.not_to change(ability_set, :name) }
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: ability_set.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: ability_set.id }) }.not_to change(AbilitySet, :count) }
    end
  end

  context 'as a user' do
    before do
      sign_in create(:user)
    end

    describe 'GET #new' do
      it { expect(get(:new, params: { teaching_cycle_id: ability_set.teaching_cycle_id })).to have_http_status(302) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: ability_set.id })).to have_http_status(302) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { teaching_cycle_id: ability_set.teaching_cycle_id, ability_set: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { teaching_cycle_id: ability_set.teaching_cycle_id, ability_set: valid_attributes }) }.not_to change(AbilitySet, :count) }
    end

    describe 'POST #sort' do
      it { expect(post(:sort, params: { teaching_cycle_id: ability_set.teaching_cycle_id, ability_set: [ability_set2.id, ability_set.id] })).to have_http_status(302) }
      it 'does not change ability_sets position' do
        post(:sort, params: { teaching_cycle_id: ability_set.teaching_cycle_id, ability_set: [ability_set2.id, ability_set.id] })
        expect(AbilitySet.ordered).to eq([ability_set, ability_set2])
      end
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: ability_set.id, ability_set: valid_attributes })).to have_http_status(302) }
      it { expect { patch(:update, params: { id: ability_set.id, ability_set: valid_attributes }) }.not_to change(ability_set, :name) }
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: ability_set.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: ability_set.id }) }.not_to change(AbilitySet, :count) }
    end
  end

  context 'as an admin' do
    before do
      sign_in create(:admin)
    end

    describe 'GET #new' do
      it { expect(get(:new, params: { teaching_cycle_id: ability_set.teaching_cycle_id })).to have_http_status(200) }
    end

    describe 'GET #edit' do
      it { expect(get(:edit, params: { id: ability_set.id })).to have_http_status(200) }
    end

    describe 'POST #create' do
      it { expect(post(:create, params: { teaching_cycle_id: ability_set.teaching_cycle_id, ability_set: valid_attributes })).to have_http_status(302) }
      it { expect { post(:create, params: { teaching_cycle_id: ability_set.teaching_cycle_id, ability_set: valid_attributes }) }.to change(AbilitySet, :count).by(1) }
      it { expect { post(:create, params: { teaching_cycle_id: ability_set.teaching_cycle_id, ability_set: valid_attributes }) }.to change(AbilityItem, :count).by(1) }
      it { expect(post(:create, params: { teaching_cycle_id: ability_set.teaching_cycle_id, ability_set: { invalid: 'attributes' } })).to have_http_status(200) }
      it { expect { post(:create, params: { teaching_cycle_id: ability_set.teaching_cycle_id, ability_set: { invalid: 'attributes' } }) }.not_to change(AbilitySet, :count) }
    end

    describe 'POST #sort' do
      it { expect(post(:sort, params: { teaching_cycle_id: ability_set.teaching_cycle_id, ability_set: [ability_set2.id, ability_set.id] })).to have_http_status(200) }
      it 'does change ability_sets position' do
        post(:sort, params: { teaching_cycle_id: ability_set.teaching_cycle_id, ability_set: [ability_set2.id, ability_set.id] })
        expect(AbilitySet.ordered).to eq([ability_set2, ability_set])
      end
    end

    describe 'PATCH #update' do
      it { expect(patch(:update, params: { id: ability_set.id, ability_set: valid_attributes })).to have_http_status(302) }
      it 'updates the ability_set' do
        patch :update, params: { id: ability_set.id, ability_set: { name: 'foo' } }
        expect(ability_set.reload.name).to eq('foo')
      end
      it { expect(patch(:update, params: { id: ability_set.id, ability_set: { name: ' ' } })).to have_http_status(200) }
      it { expect { patch(:update, params: { id: ability_set.id, ability_set: { name: ' ' } }) }.not_to change(ability_set, :name) }
      it { expect { patch(:update, params: { id: ability_set.id, ability_set: { ability_items_attributes: { '0' => { id: ability_item.id, _destroy: true } } } }) }.to change(AbilityItem, :count).by(-1) }
    end

    describe 'DELETE #destroy' do
      it { expect(delete(:destroy, params: { id: ability_set.id })).to have_http_status(302) }
      it { expect { delete(:destroy, params: { id: ability_set.id }) }.to change(AbilitySet, :count).by(-1) }
      it { expect { delete(:destroy, params: { id: ability_set.id }) }.to change(AbilityItem, :count).by(-1) }
    end
  end
end
