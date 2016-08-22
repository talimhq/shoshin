require 'rails_helper'

describe Users::RegistrationsController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'DELETE #destroy' do

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before(:each) { sign_in teacher }

      it 'destroys the account' do
        expect {
          delete :destroy
        }.to change(User, :count).by(-1)
      end
    end

    context 'as a student' do
      let(:student) { create(:student) }
      before(:each) { sign_in student }

      it 'does not destroy the account' do
        expect {
          delete :destroy
        }.not_to change(User, :count)
      end
    end

    context 'as a parent' do
      let(:parent) { create(:parent) }
      before(:each) { sign_in parent }

      it 'does not destroy the account' do
        expect {
          delete :destroy
        }.not_to change(User, :count)
      end
    end
  end
end
