class Teacher::ExercisesController < TeacherController
  before_action :authorize_author, only: [:show, :edit, :update, :destroy]

  def index
    @q = current_user.exercises.ransack(params[:q])
    @exercises = @q.result.includes(:teaching, :levels, :chapter_exercises).page(params[:page]).per(10)
  end

  def show
    @exercise = Exercise.includes(:questions, authors: :account).find(params[:id])
  end

  def new
    @exercise = current_user.exercises.new
  end

  def create
    @exercise = current_user.exercises.new(exercise_params)
    if @exercise.save
      @exercise.update(authors: [current_user])
      redirect_to [:teacher, @exercise]
    else
      render :new
    end
  end

  def edit
    # @exercise is set in before action filter
  end

  def update
    # @exercise is set in before action filter
    if @exercise.update(exercise_params)
      redirect_to [:teacher, @exercise]
    else
      render :edit
    end
  end

  def destroy
    # @exercise is set in before action filter
    @exercise.destroy
    redirect_to teacher_exercises_path
  end

  private

  def exercise_params
    params.require(:exercise).permit(:name, :statement, :time, :shared, :teaching_id, :difficulty, :exam, level_ids: [])
  end

  def authorize_author
    @exercise = Exercise.includes(:levels).find(params[:id])
    redirect_to teacher_exercises_path unless current_user.in? @exercise.authors
  end
end
