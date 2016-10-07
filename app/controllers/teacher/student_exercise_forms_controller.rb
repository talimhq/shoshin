class Teacher::StudentExerciseFormsController < ApplicationController
  before_action :authorize

  def show
  end

  private

  def authorize
    @exercise_form = UserExerciseForm.includes(:user, exercise: :questions)
                                     .find(params[:id])
    @assignment = Assignment.includes(chapter: { group: :teacher })
                                       .find_by(chapter_id: params[:chapter_id],
                                                exercise_id: params[:assignment_id])
    unless @assignment.chapter.group.teacher == current_user &&
           @exercise_form.user.in?(@assignment.chapter.group.students)
      redirect_to root_url
    end
  end
end
