class Student::MessagesController < StudentController
  before_action :authorize

  def create
    message = @group.group_notifications.create(
      user: current_user, kind: 'message',
      body: params[:group_notification][:body])
    MessageRelayJob.perform_later(message)
  end

  private

  def authorize
    @group = Group.find(params[:group_id])
    redirect_to root_url unless @group.students.include?(current_user)
  end
end
