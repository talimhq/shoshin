class ChapterPresenter < BasePresenter
  presents :chapter

  def initialize(object, template)
    super
    @lessons = chapter.lessons
    @exercises = chapter.exercises
    @undone_exercises = @exercises - h.current_user.done_exercises
    @exercises -= @undone_exercises
  end

  def lessons
    @lessons.any? ? print_lessons.join.html_safe : no_lessons
  end

  def no_lessons
    h.render 'chapters/no_lesson'
  end

  def print_lessons
    @lessons.map do|lesson|
      h.render 'chapters/lesson', chapter: chapter, lesson: lesson
    end
  end

  def undone_exercises
    @undone_exercises.any? ? print_undone_exercises.join.html_safe : no_undone_exercises
  end

  def no_undone_exercises
    h.render 'chapters/no_undone_exercise'
  end

  def print_undone_exercises
    @undone_exercises.map do |exercise|
      h.render 'chapters/undone_exercise', chapter: chapter, exercise: exercise
    end
  end

  def done_exercises
    @exercises.any? ? print_done_exercises.join.html_safe : no_done_exercises
  end

  def no_done_exercises
    h.render 'chapters/no_done_exercise'
  end

  def print_done_exercises
    @exercises.map do |exercise|
      h.render 'chapters/done_exercise', chapter: chapter, exercise: exercise
    end
  end
end
