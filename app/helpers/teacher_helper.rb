module TeacherHelper
  def teacher_exercises_path(options = {})
    options.merge!(prefered_params)
    super
  end

  def search_teacher_exercises_path(options = {})
    options.merge!(prefered_params)
    super
  end

  def teacher_lessons_path(options = {})
    options.merge!(prefered_params)
    super
  end

  def search_teacher_lessons_path(options = {})
    options.merge!(prefered_params)
    super
  end

  def teacher_teaching_cycles_path(options = {})
    options.merge!(prefered_cycle_params)
    super
  end

  private

  def prefered_params
    {
      q: {
        teaching_id_eq: current_user.preferences[:teaching_id],
        editable_levels_level_id_eq: current_user.preferences[:level_id]
      }
    }
  end

  def prefered_cycle_params
    level_id = current_user.preferences[:level_id]
    unless level_id.blank?
      cycle_id = Level.find(current_user.preferences[:level_id])&.cycle_id
    end
    {
      q: {
        teaching_id_eq: current_user.preferences[:teaching_id],
        cycle_id_eq: cycle_id
      }
    }
  end
end
