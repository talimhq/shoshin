class HomeController < ApplicationController
  def guest
    redirect_to root_url if account_signed_in?
  end

  def user
    redirect_to root_url unless account_signed_in?
  end
end
