class Admin::SchoolsController < AdminController
  def index
    @q = School.all.ransack(params[:q])
    @schools = @q.result.order(name: :asc).page(params[:page]).per(10)
  end

  def show
    @school = School.find(params[:id])
  end

  def new
    @school = School.new
  end

  def create
    @school = School.new(school_params)
    if @school.save
      flash[:success] = 'établissement ajouté.'
      redirect_to [:admin, @school]
    else
      render :new
    end
  end

  def edit
    @school = School.find(params[:id])
  end

  def update
    @school = School.find(params[:id])
    if @school.update(school_params)
      flash[:success] = 'Établissment modifié.'
      redirect_to [:admin, @school]
    else
      render :edit
    end
  end

  def destroy
    @school = School.find(params[:id])
    @school.destroy
  end

  private

  def school_params
    params.require(:school).permit(:name, :identifier, :country, :state, :city, :website, :email)
  end
end
