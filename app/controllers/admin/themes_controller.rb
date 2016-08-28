class Admin::ThemesController < AdminController
  def show
    @theme = Theme.includes(teaching_cycle: [:teaching, :cycle], expectations: :knowledge_items).find(params[:id])
  end

  def new
    teaching_cycle = TeachingCycle.includes(:teaching, cycle: :levels).find(params[:teaching_cycle_id])
    @theme = teaching_cycle.themes.new
  end

  def create
    teaching_cycle = TeachingCycle.find(params[:teaching_cycle_id])
    @theme = teaching_cycle.themes.new(theme_params)
    if @theme.save
      redirect_to admin_teaching_cycle_path(teaching_cycle)
    else
      render :new
    end
  end

  def edit
    @theme = Theme.includes(teaching_cycle: [:teaching, cycle: :levels]).find(params[:id])
  end

  def update
    @theme = Theme.find(params[:id])
    if @theme.update(theme_params)
      redirect_to admin_teaching_cycle_path(@theme.teaching_cycle)
    else
      render :edit
    end
  end

  def destroy
    @theme = Theme.find(params[:id])
    @theme.destroy
    redirect_to admin_teaching_cycle_path(@theme.teaching_cycle)
  end

  def sort
    params[:theme].each_with_index do |id, index|
      Theme.find(id).update(position: (index + 1))
    end
    head :ok
  end

  private

  def theme_params
    params.require(:theme).permit(:name, theme_levels_attributes: [:id, :level_id, :kind, :_destroy])
  end
end
