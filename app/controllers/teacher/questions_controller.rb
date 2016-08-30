class Teacher::QuestionsController < TeacherController
  before_action :load_question # sets @question for every action
  before_action :authorize_author

  def new
  end

  def create
    if @question.update(question_params)
      redirect_to [:teacher, @question.exercise]
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to [:teacher, @question.exercise]
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to [:teacher, @question.exercise]
  end

  private

  def question_params
    params.require(:question).permit(:content, :type)
  end

  def load_question
    if params[:exercise_id]
      @question = Exercise.includes(:authors).find(params[:exercise_id]).questions.new
    else
      @question = Question.find(params[:id])
    end
  end

  def authorize_author
    redirect_to [:teacher, @question.exercise] unless current_user.in? @question.authors
  end
end
