class Teacher::StudentGroupsController < TeacherController
  def index
    level = Level.find(params[:id])
    if current_user.school && current_user.school_teacher.approved
      @classrooms = current_user.school.classrooms
                                       .includes(students: :account)
                                       .where(level: level)
    end
  end
end
