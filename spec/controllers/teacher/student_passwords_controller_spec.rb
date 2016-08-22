require 'rails_helper'

RSpec.describe Teacher::StudentPasswordsController, type: :controller do
  let(:teacher) { create(:teacher) }
  let(:student) { create(:student) }
  let!(:school) { create(:classroom_student, user: student).classroom.school }

  describe 'PATCH #update' do
    context 'as a guest' do
      it 'does not reset the student password' do
        patch :update, params: { id: student.id }, format: :js
        expect(student.reload.valid_password?('123456')).to be_falsy
      end
    end

    context 'as a teacher' do
      before(:each) { sign_in teacher }

      context 'without a school' do
        it 'does not reset the student password' do
          patch :update, params: { id: student.id }, format: :js
          expect(student.reload.valid_password?('123456')).to be_falsy
        end
      end

      context 'not approved in the school' do
        before do
          create(:school_user, user: teacher, school: school, approved: false)
        end

        it 'does not reset the student password' do
          patch :update, params: { id: student.id }, format: :js
          expect(student.reload.valid_password?('123456')).to be_falsy
        end
      end

      context 'approved in the school' do
        before do
          create(:school_user, user: teacher, school: school, approved: true)
        end

        it 'resets the student password' do
          patch :update, params: { id: student.id }, format: :js
          expect(student.reload.valid_password?('123456')).to be_truthy
        end
      end

      context 'approved in another school' do
        before do
          create(:school_user, user: teacher, approved: true)
        end

        it 'does not reset the student password' do
          patch :update, params: { id: student.id }, format: :js
          expect(student.reload.valid_password?('123456')).to be_falsy
        end
      end
    end
  end
end
