class Admin::CyclesController < AdminController
  def index
    @cycles = Cycle.ordered.includes(:levels)
  end

  def new
    @cycle = Cycle.new
  end

  def create
    @cycle = Cycle.new(cycle_params)
    if @cycle.save
      redirect_to admin_cycles_path
    else
      render :new
    end
  end

  def edit
    @cycle = Cycle.includes(:levels).find(params[:id])
  end

  def update
    @cycle = Cycle.find(params[:id])
    if @cycle.update(cycle_params)
      redirect_to admin_cycles_path
    else
      render :edit
    end
  end

  def destroy
    @cycle = Cycle.find(params[:id])
    @cycle.destroy
    redirect_to admin_cycles_path
  end

  def sort
    params[:cycle].each_with_index do |cycle_id, index|
      Cycle.find(cycle_id).update(position: index + 1)
    end
    head :ok
  end

  private

  def cycle_params
    params.require(:cycle).permit(
      :name,
      levels_attributes: [:id, :name, :short_name, :level_type, :_destroy]
    )
  end
end
