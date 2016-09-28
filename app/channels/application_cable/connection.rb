module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_account

    def connect
      self.current_account = find_verified_account
      logger.add_tags 'ActionCable', "#{current_account.user_type} #{current_account.user_id}"
    end

    protected

    def find_verified_account
      if current_account = env['warden'].user
        current_account
      else
        reject_unauthorized_connection
      end
    end
  end
end
