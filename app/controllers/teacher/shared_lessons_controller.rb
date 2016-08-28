class Teacher::SharedLessonsController < TeacherController
  def index
    @q = Lesson.where(shared: true).order(popularity: :desc).ransack(params[:q])
    @lessons = @q.result.includes(:teaching).page(params[:page]).per(10)
  end

  def create
    lesson = Lesson.where(shared: true).find(params[:lesson_id])
    copy = lesson.create_copy(current_user)
    redirect_to [:teacher, copy]
  end
end
