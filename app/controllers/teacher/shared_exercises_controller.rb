class Teacher::SharedExercisesController < TeacherController
  def index
    @q = Exercise.where(shared: true).order(popularity: :desc).ransack(params[:q])
    @exercises = @q.result.includes(:teaching).page(params[:page]).per(10)
  end

  def create
    exercise = Exercise.where(shared: true).find(params[:exercise_id])
    copy = exercise.create_copy(current_user)
    redirect_to [:teacher, copy]
  end
end
