class Teacher::ThemesController < TeacherController
  def index
    @teaching_cycle = TeachingCycle.includes(themes: { expectations: :knowledge_items }).find(params[:teaching_cycle_id])  
  end
end
