class Student::UserExerciseFormsController < StudentController
  before_action :authorize
  before_action :authorize_access, only: :show

  def create
    @exercise_form = current_user.user_exercise_forms.new(exercise: @assignment.exercise)
    @exercise_form.answers = answer_attributes
    @exercise_form.auto_correct
    @exercise_form.save
    redirect_to student_chapter_assignment_result_path(@assignment.chapter_id, @assignment.exercise_id, @exercise_form.id)
  end

  def show
  end

  private

  def authorize
    @assignment = Assignment.includes(chapter: :group)
                                       .find_by(chapter_id: params[:chapter_id],
                                                exercise_id: params[:assignment_id])
    unless current_user.in? @assignment.chapter.group.students
      redirect_to root_url
    end
  end

  def authorize_access
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
