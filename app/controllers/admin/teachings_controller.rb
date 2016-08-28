class Admin::TeachingsController < AdminController
  def index
    @teachings = Teaching.ordered.includes(teaching_cycles: :cycle)
  end

  def new
    @teaching = Teaching.new
  end

  def create
    @teaching = Teaching.new(teaching_params)
    if @teaching.save
      redirect_to admin_teachings_path
    else
      render :new
    end
  end

  def edit
    @teaching = Teaching.find(params[:id])
  end

  def update
    @teaching = Teaching.find(params[:id])
    if @teaching.update(teaching_params)
      redirect_to admin_teachings_path
    else
      render :edit
    end
  end

  def destroy
    @teaching = Teaching.find(params[:id])
    @teaching.destroy
    redirect_to admin_teachings_path
  end

  private

  def teaching_params
    params.require(:teaching).permit(:name, :short_name, cycle_ids: [])
  end
end
