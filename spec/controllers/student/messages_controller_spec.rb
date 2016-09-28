require 'rails_helper'

describe Student::MessagesController, type: :controller do
  let(:group) { create(:group) }

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

    context 'as a student' do
      let(:student) { create(:student) }
      before { sign_in student.account }

      context 'who is not a part of the group' do
        it 'does not create a message' do
          expect {
            post :create, params: { group_id: group.id,
                                    group_notification: { body: 'foo' } },
                          format: :js
          }.not_to change(GroupNotification, :count)
        end
      end

      context 'who is a part of the group' do
        it 'creates a message' do
          group.update(students: [student])
          expect {
            post :create, params: { group_id: group.id,
                                    group_notification: { body: 'foo' } },
                          format: :js
          }.to change(GroupNotification, :count).by(1)
        end
      end
    end
  end
end
