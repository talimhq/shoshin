class Teacher::AssignmentsController < TeacherController
  before_action :authorize
  before_action :set_assignment, only: [:show, :edit, :update, :destroy]
  before_action :set_exercises, except: [:show, :destroy]

  def show
  end

  def new
    @assignment = @chapter.assignments.new
  end

  def create
    @assignment = @chapter.assignments.new(assignment_params)
    if @assignment.save
      flash[:notice] = 'Exercice ajouté.'
      redirect_to [:teacher, @chapter]
    else
      render :new
    end
  end

  def edit
    @exercises.unshift(@assignment.exercise)
  end

  def update
    if @assignment.update(assignment_params)
      flash[:notice] = 'Exercice mis à jour.'
      redirect_to [:teacher, @chapter]
    else
      render :edit
    end
  end

  def destroy
    @assignment.destroy
    flash[:notice] = 'Exercice supprimé.'
    redirect_to [:teacher, @chapter]
  end

  private

  def authorize
    @chapter = Chapter.includes(group: :level).find(params[:chapter_id])
    redirect_to root_url unless current_user == @chapter.teacher
  end

  def set_assignment
    @assignment = Assignment.find_by(chapter: @chapter,
                                                exercise_id: params[:id])
  end

  def assignment_params
    params.require(:assignment).permit(:exercise_id, :max_tries, :due_date)
  end

  def set_exercises
    @exercises = current_user.exercises_from_level(@chapter.level) - @chapter.exercises
  end
end
