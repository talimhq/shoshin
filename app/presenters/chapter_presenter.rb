class ChapterPresenter < BasePresenter
  presents :chapter

  def initialize(object, template)
    super
    @chapter_lessons = chapter.chapter_lessons
    @assignments = chapter.assignments
    @undone_assignments = @assignments - h.current_user.done_assignments
    @assignments -= @undone_assignments
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

  def undone_assignments
    @undone_assignments.any? ? print_undone_assignments.join.html_safe : no_undone_assignments
  end

  def no_undone_assignments
    h.render 'chapters/no_undone_assignment'
  end

  def print_undone_assignments
    @undone_assignments.map do |assignment|
      h.render 'chapters/undone_assignment', assignment: assignment
    end
  end

  def done_assignments
    @assignments.any? ? print_done_assignments.join.html_safe : no_done_assignments
  end

  def no_done_assignments
    h.render 'chapters/no_done_assignment'
  end

  def print_done_assignments
    @assignments.map do |assignment|
      h.render 'chapters/done_assignment', assignment: assignment
    end
  end
end
