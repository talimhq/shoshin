class Student::ChapterLessonsController < StudentController
  def show
    @chapter_lesson = ChapterLesson.includes(chapter: :group, lesson: :steps)
                                   .find(params[:id])
    redirect_to root_url unless current_user.in? @chapter_lesson.group.students
  end
end
