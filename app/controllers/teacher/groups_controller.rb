class Teacher::GroupsController < TeacherController
  before_action :authorize, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @group = current_user.groups.new
  end

  def create
    @group = current_user.groups.new(group_params)
    if @group.save
      flash[:notice] = 'Groupe ajouté'
      redirect_to [:teacher, @group]
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      flash[:notice] = 'Groupe mis à jour.'
      redirect_to [:teacher, @group]
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    flash[:notice] = 'Groupe supprimé.'
    redirect_to root_url
  end

  private

  def group_params
    params.require(:group).permit(:name, :level_id, :teaching_id, student_ids: [])
  end

  def authorize
    @group = Group.includes(:teacher, :teaching, :level).find(params[:id])
    redirect_to root_url unless current_user == @group.teacher
  end
end
