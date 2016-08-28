require 'rails_helper'

describe Accounts::RegistrationsController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:account] }

  describe 'DELETE #destroy' do

    context 'as a teacher' do
      before(:each) { sign_in create(:teacher_account) }

      it 'destroys the account' do
        expect {
          delete :destroy
        }.to change(Teacher, :count).by(-1)
      end
    end

    context 'as a student' do
      before(:each) { sign_in create(:student_account) }

      it 'does not destroy the account' do
        expect {
          delete :destroy
        }.not_to change(Student, :count)
      end
    end

    context 'as a parent' do
      before(:each) { sign_in create(:parent_account) }

      it 'does not destroy the account' do
        expect {
          delete :destroy
        }.not_to change(Parent, :count)
      end
    end
  end
end
