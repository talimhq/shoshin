class Teacher::ChapterExercisesController < TeacherController
  before_action :authorize
  before_action :set_chapter_exercise, only: [:edit, :update, :destroy]
  before_action :set_exercises, except: :destroy

  def new
    @chapter_exercise = @chapter.chapter_exercises.new
  end

  def create
    @chapter_exercise = @chapter.chapter_exercises.new(chapter_exercise_params)
    if @chapter_exercise.save
      flash[:notice] = 'Exercice ajouté.'
      redirect_to [:teacher, @chapter]
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @chapter_exercise.update(chapter_exercise_params)
      flash[:notice] = 'Exercice mis à jour.'
      redirect_to [:teacher, @chapter]
    else
      render :edit
    end
  end

  def destroy
    @chapter_exercise.destroy
    flash[:notice] = 'Exercice supprimé.'
    redirect_to [:teacher, @chapter]
  end

  private

  def authorize
    @chapter = Chapter.includes(:teacher).find(params[:chapter_id])
    redirect_to root_url unless current_user == @chapter.teacher
  end

  def set_chapter_exercise
    @chapter_exercise = ChapterExercise.find_by(chapter: @chapter,
                                                exercise_id: params[:id])
  end

  def chapter_exercise_params
    params.require(:chapter_exercise).permit(:exercise_id, :max_tries, :due_date)
  end

  def set_exercises
    @exercises = current_user.exercises_from_level(@chapter.level)
  end
end
