class Teacher::AbilitySetsController < TeacherController
  def index
    @teaching_cycle = TeachingCycle.includes(ability_sets: :ability_items).find(params[:teaching_cycle_id]) 
  end
end
