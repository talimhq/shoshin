# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class GroupsChannel < ApplicationCable::Channel
  def subscribed
    unless current_account.user_type == 'Parent'
      current_account.user.groups.each do |group|
        stream_from "Group: #{group.id}"
      end
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end
