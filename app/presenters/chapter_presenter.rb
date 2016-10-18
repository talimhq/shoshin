class ChapterPresenter < BasePresenter
  presents :chapter

  def initialize(object, template)
    super
    @chapter_lessons = chapter.chapter_lessons
    @exercises = chapter.exercises
    @undone_exercises = @exercises - h.current_user.done_exercises
    @exercises -= @undone_exercises
  end

  def chapter_lessons
    @chapter_lessons.any? ? print_chapter_lessons.join.html_safe : no_chapter_lessons
  end

  def no_chapter_lessons
    h.render 'chapters/no_chapter_lesson'
  end

  def print_chapter_lessons
    @chapter_lessons.map do|chapter_lesson|
      h.render 'chapters/chapter_lesson', chapter_lesson: chapter_lesson
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
