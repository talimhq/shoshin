class Teacher::ExerciseFormsController < TeacherController
  before_action :authorize_exercise, only: [:new, :create]
  before_action :authorize_exercise_form, only: [:show]

  def new
    @exercise_form = current_user.user_exercise_forms.new(exercise: @exercise)
  end

  def create
    @exercise_form = current_user.user_exercise_forms.new(exercise: @exercise)
    @exercise_form.answers = answer_attributes
    @exercise_form.auto_correct
    @exercise_form.save
    redirect_to teacher_exercise_result_path(@exercise, @exercise_form)
  end

  def show
  end

  private

  def authorize_exercise
    @exercise = Exercise.includes(:questions).find(params[:id])
    redirect_to root_url unless @exercise.is_accessible_by(current_user)
  end

  def authorize_exercise_form
    @exercise_form = UserExerciseForm.includes(exercise: :questions).find(params[:id])
    redirect_to root_url unless current_user == @exercise_form.user
  end

  def answer_attributes
    white_listed = []
    @exercise_form.questions.each do |question|
      if question.class == Questions::MultipleChoice
        white_listed << { question.id.to_s => [] }
      elsif question.class == Questions::Association
        white_listed << { question.id.to_s => question.answers.map { |answer| answer.id.to_s } }
      elsif question.class == Questions::Classify
        white_listed << { question.id.to_s => question.category_items.map { |item| item.id.to_s } }
      else
        white_listed << question.id.to_s
      end
    end
    params.require(:answers).permit(white_listed)
  end
end
