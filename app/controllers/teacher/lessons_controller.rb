class Teacher::LessonsController < TeacherController
  before_action :authorize_author, only: [:show, :edit, :update, :destroy]

  def index
    @q = current_user.lessons.ransack(params[:q])
    @lessons = @q.result.includes(:teaching, :levels, :chapter_lessons).page(params[:page]).per(10)
  end

  def show
    @lesson = Lesson.includes(:authors, :teaching, :steps).find(params[:id])
    @chapter_lessons = @lesson.chapter_lessons
                               .includes(chapter: { group: [:teaching, :level]})
  end

  def new
    @lesson = current_user.lessons.new(
      teaching_id: current_user.preferences[:teaching_id],
      level_ids: [current_user.preferences[:level_id]]
    )
  end

  def create
    @lesson = current_user.lessons.new(lesson_params)
    if @lesson.save
      @lesson.update(authors: [current_user])
      redirect_to [:teacher, @lesson.reload]
    else
      render :new
    end
  end

  def edit
    # @lesson is set in before action filter
  end

  def update
    # @lesson is set in before action filter
    if @lesson.update(lesson_params)
      redirect_to [:teacher, @lesson]
    else
      render :edit
    end
  end

  def destroy
    # @lesson is set in before action filter
    @lesson.destroy
    redirect_to teacher_lessons_path
  end

  private

  def lesson_params
    params.require(:lesson).permit(:name, :shared, :teaching_id, level_ids: [])
  end

  def authorize_author
    @lesson = Lesson.includes(:levels).find(params[:id])
    redirect_to teacher_lessons_path unless current_user.in? @lesson.authors
  end
end
