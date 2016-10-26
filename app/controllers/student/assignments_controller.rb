class Student::AssignmentsController < StudentController
  def show
    @assignment = Assignment.includes(:exercise, chapter: :group)
                            .find(params[:id])
    redirect_to root_url unless current_user.in? @assignment.group.students
  end
end
