class Teacher::StepsController < TeacherController
  before_action :authorize_author # sets @step for every action

  def new
  end

  def create
    if @step.update(step_params)
      redirect_to [:teacher, @step.lesson]
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @step.update(step_params)
      redirect_to [:teacher, @step.lesson]
    else
      render :edit
    end
  end

  def destroy
    @step.destroy
    redirect_to [:teacher, @step.lesson]
  end

  private

  def step_params
    params.require(:step).permit(:title, :content)
  end

  def authorize_author
    if params[:lesson_id]
      @step = Lesson.includes(:authors).find(params[:lesson_id]).steps.new
    else
      @step = Step.includes(lesson: :authors).find(params[:id])
    end
    redirect_to [:teacher, @step.lesson] unless current_user.in? @step.authors
  end
end
