class Teacher::ChapterLessonsController < TeacherController
  before_action :authorize

  def edit
  end

  def update
    params[:chapter] ||= { lesson_ids: [] }
    if @chapter.update(lessons: @lessons.where(id: params[:chapter][:lesson_ids]))
      flash[:notice] = 'Liste de cours mise à jour.'
      redirect_to [:teacher, @chapter]
    else
      render :edit
    end
  end

  private

  def authorize
    @chapter = Chapter.includes(:group).find(params[:id])
    redirect_to root_url unless current_user == @chapter.teacher
    fetch_lessons
  end

  def fetch_lessons
    @lessons = current_user.lessons.where(
      "level_ids @> '{#{@chapter.group.level_id}}'::int[]"
    ).order(:name)
  end
end
