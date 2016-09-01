require 'rails_helper'

RSpec.describe Student::GroupsController, type: :controller do
  let(:group) { create(:group) }

  describe 'GET #show' do
    context 'as a guest' do
      it 'redirects' do
        get :show, params: { id: group.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a student' do
      let(:student) { create(:student) }
      before { sign_in student.account }

      context 'not in the group' do
        it 'redirects' do
          get :show, params: { id: group.id }
          expect(response).to have_http_status(302)
        end
      end

      context 'in the group' do
        before { group.update(students: [student]) }

        it 'is a success' do
          get :show, params: { id: group.id }
          expect(response).to have_http_status(200)
        end
      end
    end
  end
end
