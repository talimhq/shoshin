require 'rails_helper'

RSpec.describe Teacher::PreferencesController, type: :controller do
  describe 'PATCH #update' do
    context 'as a guest' do
      it 'redirects' do
        patch :update
        expect(response).to have_http_status(302)
      end
    end

    context 'as student' do
      it 'redirects' do
        sign_in create(:student_account)
        patch :update
        expect(response).to have_http_status(302)
      end
    end

    context 'as parent' do
      it 'redirects' do
        sign_in create(:parent_account)
        patch :update
        expect(response).to have_http_status(302)
      end
    end

    context 'as teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'with valid attributes' do
        let(:level) { create(:level) }

        it 'redirects' do
          patch :update, params: { teacher: { preferences: { level_id: level.id } } }
          expect(response).to have_http_status(302)
        end

        it 'updates the teacher preferences' do
          patch :update, params: { teacher: { preferences: { level_id: level.id } } }
          expect(teacher.reload.preferences[:level_id]).to eq(level.id.to_s)
        end
      end
    end
  end
end
