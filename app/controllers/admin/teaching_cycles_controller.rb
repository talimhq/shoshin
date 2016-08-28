class Admin::TeachingCyclesController < AdminController
  def show
    @teaching_cycle = TeachingCycle.includes(themes: :levels).find(params[:id])
  end
end
