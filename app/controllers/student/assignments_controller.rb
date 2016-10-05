class Student::AssignmentsController < StudentController
  before_action :authorize

  def show
    @exercise_form = current_user.user_exercise_forms
                                 .new(exercise_id: params[:id])
  end

  private

  def authorize
    @assignment = Assignment.includes(chapter: :group)
                                       .find_by(chapter_id: params[:chapter_id],
                                                exercise_id: params[:id])
    unless current_user.in? @assignment.chapter.group.students
      redirect_to root_url
    end
  end
end
