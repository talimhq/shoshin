class Teacher::StudentExerciseFormsController < ApplicationController
  before_action :authorize

  def show
  end

  private

  def authorize
    @exercise_form = UserExerciseForm.includes(:user, exercise: :questions)
                                     .find(params[:id])
    @chapter_exercise = ChapterExercise.includes(chapter: { group: :teacher })
                                       .find_by(chapter_id: params[:chapter_id],
                                                exercise_id: params[:exercise_id])
    unless @chapter_exercise.chapter.group.teacher == current_user &&
           @exercise_form.user.in?(@chapter_exercise.chapter.group.students)
      redirect_to root_url
    end
  end
end
