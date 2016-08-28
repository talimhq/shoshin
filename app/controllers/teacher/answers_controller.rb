class Teacher::AnswersController < TeacherController
  before_action :load_question # sets @question
  before_action :authorize_author

  def index
  end

  def update
    if @question.update(answers_params)
      redirect_to teacher_exercise_path(@question.exercise)
    else
      render :index
    end
  end

  private

  def answers_params
    case @question.print_type
    when 'input'
      params.require('questions_input').permit(answers_attributes: [:id, :content, :_destroy])
    when 'single_choice'
      params.require('questions_single_choice').permit(answers_attributes: [:id, :content, :correct, :_destroy])
    when 'multiple_choice'
      params.require('questions_multiple_choice').permit(answers_attributes: [:id, :content, :correct, :_destroy])
    when 'classify'
      params.require('questions_classify').permit(answers_attributes: [:id, :name, :_destroy, category_items_attributes: [:id, :content, :_destroy]])
    when 'association'
      params.require('questions_association').permit(answers_attributes: [:id, :left, :right, :_destroy])
    when 'file_upload'
      params.require('questions_file_upload').permit(answers_attributes: [:id, :file_format, :_destroy])
    end
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def authorize_author
    redirect_to [:teacher, @question.exercise] unless current_user.in? @question.authors
  end
end
