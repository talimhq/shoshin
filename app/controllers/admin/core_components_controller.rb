class Admin::CoreComponentsController < AdminController
  def index
    @core_components = CoreComponent.ordered
  end

  def new
    @core_component = CoreComponent.new
  end

  def create
    @core_component = CoreComponent.new(core_component_params)
    if @core_component.save
      redirect_to admin_core_components_path
    else
      render :new
    end
  end

  def edit
    @core_component = CoreComponent.find(params[:id])
  end

  def update
    @core_component = CoreComponent.find(params[:id])
    if @core_component.update(core_component_params)
      redirect_to admin_core_components_path
    else
      render :edit
    end
  end

  def destroy
    @core_component = CoreComponent.find(params[:id])
    @core_component.destroy
    redirect_to admin_core_components_path
  end

  private

  def core_component_params
    params.require(:core_component).permit(:name)
  end
end
