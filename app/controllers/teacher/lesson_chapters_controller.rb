class Teacher::LessonChaptersController < TeacherController
  before_action :authorize
  before_action :set_groups

  def new
    @chapter_lesson = @lesson.chapter_lessons.new
  end

  def create
    @chapter_lesson = @lesson.chapter_lessons.new(chapter_lesson_params)
    if @chapter_lesson.save
      flash[:notice] = 'Cours ajouté au groupe'
      redirect_to [:teacher, @lesson]
    else
      render :new
    end
  end

  private

  def authorize
    @lesson = Lesson.includes(:authors).find(params[:lesson_id])
    redirect_to root_url unless current_user.in? @lesson.authors
  end

  def set_groups
    @groups = current_user.groups.includes(:level, :teaching, :chapters)
  end

  def chapter_lesson_params
    params.require(:chapter_lesson).permit(:chapter_id)
  end
end
