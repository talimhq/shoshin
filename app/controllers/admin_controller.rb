class AdminController < ApplicationController
  include Authorization
  before_action :restrict_to_admins
end
