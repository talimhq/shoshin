class Teacher::AuthorshipsController < TeacherController
  before_action :set_editable
  before_action :restrict_to_authors

  def index
  end

  def new
  end

  def create
    @editable.authorships.create(authorship_params)
    render :index
  end

  def destroy
    @editable.authorships.find(params[:id]).destroy
    if @editable.reload.authorships.any?
      redirect_to([:teacher, @editable, :authorships])
    else
      @editable.destroy
      redirect_to([:teacher, :lessons])
    end
  end

  private

  def restrict_to_authors
    redirect_to [:teacher, :lessons] unless current_user.in? @editable.authors
  end

  def set_editable
    case params[:editable_type]
    when 'Lesson'
      @editable = Lesson.includes(:authors, :teaching).find(params[:lesson_id])
    when 'Exercise'
      @editable = Exercise.find(params[:exercise_id])
    end
  end

  def authorship_params
    params.require(:authorship).permit(:teacher_id)
  end
end
