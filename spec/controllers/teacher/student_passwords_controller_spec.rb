require 'rails_helper'

RSpec.describe Teacher::StudentPasswordsController, type: :controller do
  let(:teacher) { create(:teacher) }
  let!(:classroom) { create(:classroom) }
  let(:school) { classroom.school }
  let!(:student) { create(:student, classroom: classroom) }

  describe 'PATCH #update' do
    context 'as a guest' do
      it 'does not reset the student password' do
        patch :update, params: { id: student.id }, format: :js
        expect(student.reload.account.valid_password?('123456')).to be_falsy
      end
    end

    context 'as a teacher' do
      before(:each) { sign_in teacher.account }

      context 'without a school' do
        it 'does not reset the student password' do
          patch :update, params: { id: student.id }, format: :js
          expect(student.reload.account.valid_password?('123456')).to be_falsy
        end
      end

      context 'not approved in the school' do
        it 'does not reset the student password' do
          school.update(pending_teachers: [teacher])
          patch :update, params: { id: student.id }, format: :js
          expect(student.reload.account.valid_password?('123456')).to be_falsey
        end
      end

      context 'approved in the school' do
        it 'resets the student password' do
          school.update(teachers: [teacher])
          patch :update, params: { id: student.id }, format: :js
          expect(student.reload.account.valid_password?('123456')).to be_truthy
        end
      end

      context 'approved in another school' do
        it 'does not reset the student password' do
          create(:school_teacher, teacher: teacher, approved: true)
          patch :update, params: { id: student.id }, format: :js
          expect(student.reload.account.valid_password?('123456')).to be_falsy
        end
      end
    end
  end
end
