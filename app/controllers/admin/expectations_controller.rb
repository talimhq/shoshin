class Admin::ExpectationsController < AdminController
  def new
    theme = Theme.find(params[:theme_id])
    @expectation = theme.expectations.new
  end

  def create
    theme = Theme.find(params[:theme_id])
    @expectation = theme.expectations.new(expectation_params)
    if @expectation.save
      redirect_to admin_theme_path(@expectation.theme)
    else
      render :new
    end
  end

  def edit
    @expectation = Expectation.find(params[:id])
  end

  def update
    @expectation = Expectation.find(params[:id])
    if @expectation.update(expectation_params)
      redirect_to admin_theme_path(@expectation.theme)
    else
      render :edit
    end
  end

  def destroy
    @expectation = Expectation.find(params[:id])
    @expectation.destroy
    redirect_to admin_theme_expectations_path(@expectation.theme)
  end

  private

  def expectation_params
    params.require(:expectation).permit(:name, knowledge_items_attributes: [:id, :name, :_destroy])
  end
end

