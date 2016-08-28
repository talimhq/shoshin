class Teacher::ThemesController < TeacherController
  def index
    @teaching_cycle = TeachingCycle.includes(:themes).find(params[:teaching_cycle_id])  
  end

  def show
    @theme = Theme.includes(expectations: :knowledge_items, teaching_cycle: [:teaching, :cycle]).find(params[:id])
  end
end
