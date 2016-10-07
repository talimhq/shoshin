require 'rails_helper'

RSpec.describe Teacher::StudentGroupsController, type: :controller do
  let(:group) { create(:group) }
  let(:teacher) { create(:teacher, school: classroom.school) }
  let(:classroom) { create(:classroom, level: group.level) }
  let(:student) { create(:student, classroom: classroom) }

  before { sign_in teacher.account  }

  describe 'GET #edit' do
    context 'as a teacher who does not own the group' do
      it 'redirects' do
        get :edit, params: { id: group.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher who owns the group' do
      it 'is a success' do
        group.update(teacher: teacher)
        get :edit, params: { id: group.id }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'PATCH #update' do
    before { group.update(teacher: teacher) }
    context 'with valid data' do
      it 'increases the student_group count' do
        expect {
          patch :update, params: { id: group.id,
                                   group: { student_ids: [student.id] } }
        }.to change(group.student_groups, :count).by(1)
      end
    end
  end
end
