class Admin::AbilitySetsController < AdminController
  def new
    teaching_cycle = TeachingCycle.includes(:teaching, :cycle).find(params[:teaching_cycle_id])
    @ability_set = teaching_cycle.ability_sets.new
  end

  def create
    teaching_cycle = TeachingCycle.find(params[:teaching_cycle_id])
    @ability_set = teaching_cycle.ability_sets.new(ability_set_params)
    if @ability_set.save
      redirect_to admin_teaching_cycle_path(teaching_cycle)
    else
      render :new
    end
  end

  def edit
    @ability_set = AbilitySet.find(params[:id])
  end

  def update
    @ability_set = AbilitySet.find(params[:id])
    if @ability_set.update(ability_set_params)
      redirect_to admin_teaching_cycle_path(@ability_set.teaching_cycle)
    else
      render :edit
    end
  end

  def destroy
    @ability_set = AbilitySet.find(params[:id])
    @ability_set.destroy
    redirect_to admin_teaching_cycle_path(@ability_set.teaching_cycle)
  end

  def sort
    params[:ability_set].each_with_index do |ability_set_id, index|
      AbilitySet.find(ability_set_id).update(position: index + 1)
    end
    head :ok
  end

  private

  def ability_set_params
    params.require(:ability_set).permit(:name, ability_items_attributes: [:id, :name, :_destroy])
  end
end
