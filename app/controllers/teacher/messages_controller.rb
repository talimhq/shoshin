class Teacher::MessagesController < TeacherController
  before_action :authorize, only: [:create]

  def create
    message = @group.group_notifications.create(
      user: current_user, kind: 'message',
      body: params[:group_notification][:body])
    MessageRelayJob.perform_later(message)
  end

  def destroy
    message = GroupNotification.find(params[:id])
    message.destroy if message.group.teacher == current_user
    head :ok
  end

  private

  def authorize
    @group = Group.find(params[:group_id])
    redirect_to root_url unless @group.teacher == current_user
  end
end
