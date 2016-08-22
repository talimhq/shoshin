require 'rails_helper'

RSpec.describe Admin::ExpectationsController, type: :controller do
  let!(:expectation) { create(:expectation) }
  let!(:knowledge_item) { create(:knowledge_item, expectation: expectation) }
  let(:valid_attributes) {
    {
      name: Faker::Lorem.word,
      theme_id: expectation.theme_id,
      knowledge_items_attributes: [
        { name: Faker::Lorem.word }
      ]
    }
  }

  context 'as a guest' do
    it { expect(get(:new, params: { theme_id: expectation.theme_id })).to have_http_status(302) }
    it { expect(post(:create, params: { theme_id: expectation.theme_id, expectation: valid_attributes })).to have_http_status(302) }
    it { expect { post(:create, params: { theme_id: expectation.theme_id, expectation: valid_attributes }) }.not_to change(Expectation, :count) }
    it { expect(get(:edit, params: { id: expectation.id })).to have_http_status(302) }
    it 'does not update the expectation' do
      patch :update, params: { id: expectation.id, name: 'foo' }
      expect(expectation.reload.name).not_to eq('foo')
    end
    it { expect(delete(:destroy, params: { id: expectation.id })).to have_http_status(302) }
    it { expect { delete :destroy, params: { id: expectation.id } }.not_to change(Expectation, :count) }
  end

  context 'as a user' do
    before { sign_in create(:user) }
    
    it { expect(get(:new, params: { theme_id: expectation.theme_id })).to have_http_status(302) }
    it { expect(post(:create, params: { theme_id: expectation.theme_id, expectation: valid_attributes })).to have_http_status(302) }
    it { expect { post(:create, params: { theme_id: expectation.theme_id, expectation: valid_attributes }) }.not_to change(Expectation, :count) }
    it { expect(get(:edit, params: { id: expectation.id })).to have_http_status(302) }
    it 'does not update the expectation' do
      patch :update, params: { id: expectation.id, expectation: { name: 'foo' } }
      expect(expectation.reload.name).not_to eq('foo')
    end
    it { expect(delete(:destroy, params: { id: expectation.id })).to have_http_status(302) }
    it { expect { delete :destroy, params: { id: expectation.id } }.not_to change(Expectation, :count) }

  end

  context 'as an admin' do
    before { sign_in create(:admin) }

    it { expect(get(:new, params: { theme_id: expectation.theme_id })).to have_http_status(200) }
    it { expect(post(:create, params: { theme_id: expectation.theme_id, expectation: { invalid: 'attributes' } })).to have_http_status(200) }
    it { expect(post(:create, params: { theme_id: expectation.theme_id, expectation: valid_attributes })).to have_http_status(302) }
    it { expect { post(:create, params: { theme_id: expectation.theme_id, expectation: valid_attributes }) }.to change(Expectation, :count).by(1) }
    it { expect { post(:create, params: { theme_id: expectation.theme_id, expectation: valid_attributes }) }.to change(KnowledgeItem, :count).by(1) }
    it { expect(get(:edit, params: { id: expectation.id })).to have_http_status(200) }
    it 'updates the expectation' do
      patch :update, params: { id: expectation.id, expectation: { name: 'foo' } }
      expect(expectation.reload.name).to eq('foo')
    end
    it 're renders the page with invalid data' do
      patch :update, params: { id: expectation.id, expectation: { name: nil } }
      expect(response).to have_http_status(200)
    end
    it 'destroys knowledge items' do
      expect {
        patch :update, params: { id: expectation.id, expectation: { knowledge_items_attributes: [{ id:knowledge_item.id, _destroy: true }] } }
      }.to change(KnowledgeItem, :count).by(-1)
    end
    it { expect(delete(:destroy, params: { id: expectation.id })).to have_http_status(302) }
    it { expect { delete :destroy, params: { id: expectation.id } }.to change(Expectation, :count).by(-1) }
    it { expect { delete :destroy, params: { id: expectation.id } }.to change(KnowledgeItem, :count).by(-1) }
  end
end
