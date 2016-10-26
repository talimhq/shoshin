require 'rails_helper'

RSpec.describe Student::AssignmentsController, type: :controller do
  let(:assignment) { create(:assignment) }

  describe 'GET #show' do
    context 'as a guest' do
      it 'redirects' do
        get :show, params: { id: assignment.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a student' do
      let(:student) { create(:student) }
      before { sign_in student.account }

      it 'redirects if student does not belong in the group' do
        get :show, params: { id: assignment.id }
        expect(response).to have_http_status(302)
      end

      it 'is a success if student belongs in the group' do
        assignment.group.update(students: [student])
        get :show, params: { id: assignment.id }
        expect(response).to have_http_status(200)
      end
    end
  end
end
