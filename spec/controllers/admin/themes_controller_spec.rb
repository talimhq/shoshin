require 'rails_helper'

RSpec.describe Admin::ThemesController, type: :controller do
  let!(:theme) { create(:theme) }
  let(:valid_attributes) {
    {
      name: Faker::Lorem.word,
      theme_levels_attributes: [
        { level_id: create(:level).id, kind: ThemeLevel.kinds.sample }
      ]
    }
  }

  context 'as a guest' do
    it { expect(get(:show, params: { id: theme.id })).to have_http_status(302) }
    it { expect(get(:new, params: { teaching_cycle_id: theme.teaching_cycle_id })).to have_http_status(302) }
    it { expect(post(:create, params: { teaching_cycle_id: theme.teaching_cycle_id, theme: valid_attributes })).to have_http_status(302) }
    it { expect { post(:create, params: { teaching_cycle_id: theme.teaching_cycle_id, theme: valid_attributes }) }.not_to change(Theme, :count) }
    it { expect(get(:edit, params: { id: theme.id })).to have_http_status(302) }
    it 'does not update the theme' do
      patch :update, params: { id: theme.id, theme: { name: 'foo' } }
      expect(theme.reload.name).not_to eq('foo')
    end
    it { expect(delete(:destroy, params: { id: theme.id })).to have_http_status(302) }
    it { expect { delete(:destroy, params: { id: theme.id }) }.not_to change(Theme, :count) }
  end

  context 'as a user' do
    before { sign_in create(:user_account) }

    it { expect(get(:show, params: { id: theme.id })).to have_http_status(302) }
    it { expect(get(:new, params: { teaching_cycle_id: theme.teaching_cycle_id })).to have_http_status(302) }
    it { expect(post(:create, params: { teaching_cycle_id: theme.teaching_cycle_id, theme: valid_attributes })).to have_http_status(302) }
    it { expect { post(:create, params: { teaching_cycle_id: theme.teaching_cycle_id, theme: valid_attributes }) }.not_to change(Theme, :count) }
    it { expect(get(:edit, params: { id: theme.id })).to have_http_status(302) }
    it 'does not update the theme' do
      patch :update, params: { id: theme.id, theme: { name: 'foo' } }
      expect(theme.reload.name).not_to eq('foo')
    end
    it { expect(delete(:destroy, params: { id: theme.id })).to have_http_status(302) }
    it { expect { delete(:destroy, params: { id: theme.id }) }.not_to change(Theme, :count) }
  end

  context 'as an admin' do
    before { sign_in create(:admin_account) }

    it { expect(get(:show, params: { id: theme.id })).to have_http_status(200) }
    it { expect(get(:new, params: { teaching_cycle_id: theme.teaching_cycle_id })).to have_http_status(200) }
    it { expect(post(:create, params: { teaching_cycle_id: theme.teaching_cycle_id, theme: valid_attributes })).to have_http_status(302) }
    it { expect { post(:create, params: { teaching_cycle_id: theme.teaching_cycle_id, theme: valid_attributes }) }.to change(Theme, :count).by(1) }
    it { expect { post(:create, params: { teaching_cycle_id: theme.teaching_cycle_id, theme: valid_attributes }) }.to change(ThemeLevel, :count).by(1) }
    it { expect(post(:create, params: { teaching_cycle_id: theme.teaching_cycle_id, theme: { invalid: 'attributes' } })).to have_http_status(200) }
    it { expect { post(:create, params: { teaching_cycle_id: theme.teaching_cycle_id, theme: { invalid: 'attributes' } }) }.not_to change(Theme, :count) }
    it { expect(get(:edit, params: { id: theme.id })).to have_http_status(200) }

    it 'updates the theme' do
      patch :update, params: { id: theme.id, theme: { name: 'foo' } }
      expect(theme.reload.name).to eq('foo')
    end

    it 'can delete a theme_level' do
      theme_level = create(:theme_level, theme: theme)
      expect {
        patch :update, params: { id: theme.id, theme: { theme_levels_attributes: [{ id: theme_level.id, _destroy: '1' }] } }
      }.to change(ThemeLevel, :count).by(-1)
    end

    it 'cannot delete last theme_level' do
      theme_level = theme.theme_levels.first
      expect {
        patch :update, params: { id: theme.id, theme: { theme_levels_attributes: [{ id: theme_level.id, _destroy: true }] } }
      }.not_to change(ThemeLevel, :count)
    end

    it { expect(patch(:update, params: { id: theme.id, theme: { name: 'foo' } })).to have_http_status(302) }
    it { expect(patch(:update, params: { id: theme.id, theme: { name: '' } })).to have_http_status(200) }
    it { expect(delete(:destroy, params: { id: theme.id })).to have_http_status(302) }
    it { expect { delete(:destroy, params: { id: theme.id }) }.to change(Theme, :count).by(-1) }
    it { expect { delete(:destroy, params: { id: theme.id }) }.to change(ThemeLevel, :count).by(-1) }
  end
end
