class Admin::SchoolTeachersController < ApplicationController
  def update
    @school_teacher = SchoolTeacher.find_by(school_id: params[:school_id],
                                            teacher_id: params[:teacher_id])
    @school_teacher.update(approved: true)
    @school_teacher.teacher.update(approved: true)
    redirect_to [:admin, @school_teacher.school]
  end

  def destroy
    @school_teacher = SchoolTeacher.find_by(school_id: params[:school_id],
                                            teacher_id: params[:teacher_id])
    @school_teacher.destroy
    redirect_to [:admin, @school_teacher.school]
  end
end
