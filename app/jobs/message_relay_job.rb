class MessageRelayJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast "Group: #{message.group_id}",
      message: ApplicationController.render(message),
      group_id: message.group_id
  end
end
