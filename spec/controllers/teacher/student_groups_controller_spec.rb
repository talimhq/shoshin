require 'rails_helper'

RSpec.describe Teacher::StudentGroupsController, type: :controller do
  let(:teacher) { create(:teacher) }
  let(:student) { create(:student) }
  let(:classroom) { student.classroom }
  let(:level) { classroom.level }

  before { sign_in teacher.account  }

  describe 'GET #index' do
    context 'as a teacher without a school' do
      it 'redirects' do
        get :index, xhr: true, params: { id: level.id }
        expect(response).to have_http_status(200)
      end
    end

    context 'as a teacher with a school' do
      before { create(:school_teacher, teacher: teacher, school: classroom.school, approved: true) }

      it 'is a success' do
        get :index, xhr: true, params: { id: level.id }
        expect(response).to have_http_status(200)
      end
    end
  end
end
