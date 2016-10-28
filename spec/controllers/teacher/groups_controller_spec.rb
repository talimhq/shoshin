require 'rails_helper'

RSpec.describe Teacher::GroupsController, type: :controller do
  let!(:group) { create(:group) }
  let(:valid_attributes) {
    { level_id: create(:level).id, teaching_id: create(:teaching).id }
  }

  describe 'GET #index' do
    context 'as a guest' do
      it 'redirects' do
        get :index
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before(:each) { sign_in teacher.account }

      it 'is a success' do
        get :index
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET #show' do
    context 'as a guest' do
      it 'redirects' do
        get :show, params: { id: group.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who does not own the group' do
        it 'redirects' do
          get :show, params: { id: group.id }
          expect(response).to have_http_status(302)
        end
      end

      context 'who owns the group' do
        before { group.update(teacher: teacher) }

        it 'is a success' do
          get :show, params: { id: group.id }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'GET #new' do
    context 'as a guest' do
      it 'redirects' do
        get :new
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      it 'is a success' do
        get :new
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET #edit' do
    context 'as a guest' do
      it 'redirects' do
        get :edit, params: { id: group.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who does not own the group' do
        it 'redirects' do
          get :edit, params: { id: group.id }
          expect(response).to have_http_status(302)
        end
      end

      context 'who owns the group' do
        before { group.update(teacher: teacher) }

        it 'is a success' do
          get :edit, params: { id: group.id }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'POST #create' do
    context 'as a guest' do
      it 'does not create a group' do
        expect {
          post :create, params: { group: valid_attributes }
        }.not_to change(Group, :count)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'with valid data' do
        it 'creates a group' do
          expect {
            post :create, params: { group: valid_attributes }
          }.to change(Group, :count).by(1)
        end

        it 'redirects' do
          post :create, params: { group: valid_attributes }
          expect(response).to have_http_status(302)
        end
      end

      context 'with student_ids' do
        it 'creates student_group' do
          school = create(:school)
          create(:school_teacher, school: school, teacher: teacher,
                                  approved: true)
          level = create(:level)
          teaching = create(:teaching)
          classroom = create(:classroom, school: school, level: level)
          student = create(:student, classroom: classroom)
          expect {
            post :create, params: { group: { level_id: level.id, teaching_id: teaching.id, student_ids: [student.id] } }
          }.to change(StudentGroup, :count).by(1)
        end
      end

      context 'with invalid data' do
        it 'does not create a group' do
          expect {
            post :create, params: { group: { invalid: 'attributes' } }
          }.not_to change(Group, :count)
        end

        it 're renders the page' do
          post :create, params: { group: { invalid: 'attributes' } }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'PATCH #update' do
    context 'as a guest' do
      it 'does not update the group' do
        patch :update, params: { id: group.id, group: { name: 'foo' } }
        expect(group.reload.name).not_to eq('foo')
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who does not own the group' do
        it 'does not update the group' do
          patch :update, params: { id: group.id, group: { name: 'foo' } }
          expect(group.reload.name).not_to eq('foo')
        end
      end

      context 'who owns the group' do
        before { group.update(teacher: teacher) }

        context 'with valid data' do
          it 'updates the group' do
            patch :update, params: { id: group.id, group: { name: 'foo' } }
            expect(group.reload.name).to eq('foo')
          end

          it 'redirects' do
            patch :update, params: { id: group.id, group: { name: 'foo' } }
            expect(response).to have_http_status(302)
          end
        end

        context 'with invalid data' do
          it 'does not update the group' do
            patch :update, params: { id: group.id, group: { level_id: '' } }
            expect(group.reload.level_id).not_to be_nil
          end

          it 're renders the page' do
            patch :update, params: { id: group.id, group: { level_id: '' } }
            expect(response).to have_http_status(200)
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as a guest' do
      it 'does not destroy the group' do
        expect {
          delete :destroy, params: { id: group.id }
        }.not_to change(Group, :count)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who does not own the group' do
        it 'does not destroy group' do
          expect {
            delete :destroy, params: { id: group.id }
          }.not_to change(Group, :count)
        end
      end

      context 'who owns the group' do
        before { group.update!(teacher: teacher) }

        it 'destroys the group' do
          expect {
            delete :destroy, params: { id: group.id }
          }.to change(Group, :count).by(-1)
        end
      end
    end
  end
end
