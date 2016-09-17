class Teacher::SharedLessonsController < TeacherController
  def index
    @q = Lesson.where(shared: true).order(popularity: :desc).ransack(params[:q])
    @lessons = @q.result.includes(:teaching, :levels).page(params[:page]).per(10)
  end

  def show
    @lesson = Lesson.includes(:teaching, :levels, :steps).find(params[:id])
    redirect_to root_url unless @lesson.is_accessible_by(current_user)
  end

  def create
    lesson = Lesson.where(shared: true).find(params[:lesson_id])
    copy = lesson.create_copy(current_user)
    redirect_to [:teacher, copy]
  end
end
