class Teacher::TeachingCyclesController < TeacherController
  def index
    @q = TeachingCycle.ordered.ransack(params[:q])
    @teaching_cycles = @q.result.page(params[:page]).per(10)
  end
end
