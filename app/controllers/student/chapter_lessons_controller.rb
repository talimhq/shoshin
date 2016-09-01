class Student::ChapterLessonsController < StudentController
  def show
    @chapter_lesson = ChapterLesson.includes(chapter: :group, lesson: :steps)
                                   .find_by(chapter_id: params[:chapter_id],
                                            lesson_id: params[:id])
    redirect_to root_url unless current_user.in? @chapter_lesson.chapter.group.students
  end
end
