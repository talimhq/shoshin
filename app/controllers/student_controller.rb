class StudentController < ApplicationController
  include Authorization
  before_action :restrict_to_students
end
