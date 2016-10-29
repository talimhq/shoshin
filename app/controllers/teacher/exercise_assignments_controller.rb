class Teacher::ExerciseAssignmentsController < TeacherController
  before_action :authorize
  before_action :set_groups

  def new
    @assignment = @exercise.assignments.new
  end

  def create
    @assignment = @exercise.assignments.new(assignment_params)
    if @assignment.save
      flash[:notice] = 'Exercice ajouté au groupe'
      redirect_to [:teacher, @exercise]
    else
      render :new
    end
  end

  private

  def authorize
    @exercise = Exercise.includes(:authors).find(params[:exercise_id])
    redirect_to root_url unless current_user.in? @exercise.authors
  end

  def set_groups
    @groups = current_user.groups.includes(:level, :teaching, :chapters)
  end

  def assignment_params
    params.require(:assignment).permit(:chapter_id)
  end
end
