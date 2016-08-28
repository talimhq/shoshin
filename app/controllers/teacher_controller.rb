class TeacherController < ApplicationController
  include Authorization
  before_action :restrict_to_teachers
end
