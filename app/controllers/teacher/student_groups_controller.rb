class Teacher::StudentGroupsController < TeacherController
  before_action :authorize

  def edit
  end

  def update
    if @group.update(student_groups_params)
      flash[:notice] = 'Liste d\'élève mise à jour.'
      redirect_to [:teacher, @group]
    else
      render :edit
    end
  end

  private

  def authorize
    @group = Group.includes(:teacher, :students).find(params[:id])
    redirect_to root_url unless current_user == @group.teacher
  end

  def student_groups_params
    params.require(:group).permit(student_ids: [])
  end
end
