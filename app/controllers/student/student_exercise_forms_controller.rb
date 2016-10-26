class Student::StudentExerciseFormsController < StudentController
  before_action :authorize_assignment, only: [:new, :create]

  def new
    @exercise_form = StudentExerciseForm.new(student: current_user,
                                             assignment: @assignment)
  end

  def create
    @exercise_form = StudentExerciseForm.new(student: current_user,
                                             assignment: @assignment)
    @exercise_form.answers = answer_attributes
    @exercise_form.auto_correct
    @exercise_form.save
    redirect_to student_exercise_form_path(@exercise_form)
  end

  def show
    @exercise_form = StudentExerciseForm.includes(:student, assignment: { exercise: :questions })
                                        .find(params[:id])
    redirect_to root_url unless current_user == @exercise_form.student
  end

  private

  def authorize_assignment
    @assignment = Assignment.includes(chapter: :group)
                            .find(params[:assignment_id])
    redirect_to root_url unless current_user.in? @assignment.group.students
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
