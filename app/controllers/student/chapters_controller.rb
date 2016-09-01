class Student::ChaptersController < StudentController
  def show
    @chapter = Chapter.includes(:group, :lessons, :exercises).find(params[:id])
    redirect_to root_url unless current_user.in? @chapter.group.students
  end
end
