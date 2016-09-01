class Student::LessonsController < StudentController
  def show
    @lesson = Lesson.includes(:steps).find(params[:id])
    redirect_to root_url unless current_user.can_access_lesson?(@lesson)
  end
end
