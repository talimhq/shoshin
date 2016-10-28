require 'rails_helper'

describe Teacher::MessagesController, type: :controller do
  let(:group) { create(:group) }
  let!(:message) { create(:group_notification) }

  describe 'POST #create' do
    context 'as a guest' do
      it 'does not create a message' do
        expect {
          post :create, params: { group_id: group.id,
                                  group_notification: { body: 'foo' } },
                        format: :js
        }.not_to change(GroupNotification, :count)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who does not own the group' do
        it 'does not create a message' do
          expect {
            post :create, params: { group_id: group.id,
                                    group_notification: { body: 'foo' } },
                          format: :js
          }.not_to change(GroupNotification, :count)
        end
      end

      context 'who owns the group' do
        it 'creates a message' do
          group.update(teacher: teacher)
          expect {
            post :create, params: { group_id: group.id,
                                    group_notification: { body: 'foo' } },
                          format: :js
          }.to change(GroupNotification, :count).by(1)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as a guest' do
      it 'does not destroy the message' do
        expect {
          delete :destroy, params: { id: message.id }
        }.not_to change(GroupNotification, :count)
      end
    end

    context 'as a student' do
      before { sign_in create(:student_account) }

      it 'does not destroy the message' do
        expect {
          delete :destroy, params: { id: message.id }
        }.not_to change(GroupNotification, :count)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who does not own the group' do
        it 'does not destroy the message' do
          expect {
            delete :destroy, params: { id: message.id }
          }.not_to change(GroupNotification, :count)
        end
      end

      context 'who owns the group' do
        before { message.group.update(teacher: teacher) }
        it 'destroys the message' do
          expect {
            delete :destroy, params: { id: message.id }
          }.to change(GroupNotification, :count).by(-1)
        end
      end
    end
  end
end
