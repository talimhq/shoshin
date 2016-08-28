class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  def current_user
    current_account.user
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :account_update, keys: [:first_name, :last_name, :email, :password,
                              :password_confirmation, :current_password]
    )
  end
end
