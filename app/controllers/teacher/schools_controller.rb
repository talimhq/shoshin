class Teacher::SchoolsController < TeacherController
  before_action :authorize_new, only: [:new, :create]
  before_action :authorize_show, only: [:show]

  def new
    @school = School.new
  end

  def create
    @school = School.new(school_params)
    if @school.save
      SchoolTeacher.create(school: @school, teacher: current_user, approved: false)
      flash[:notice] = 'Établissement enregistré'
      redirect_to teacher_school_path(@school)
    else
      render :new
    end
  end

  def show
  end

  private

  def authorize_new
    redirect_to [:teacher, current_user.school] if current_user.school_teacher
  end

  def authorize_show
    @school = School.includes(classrooms: :level).find(params[:id])
    redirect_to root_url unless current_user.school == @school
  end

  def school_params
    params.require(:school).permit(
      :name, :identifier, :country, :state, :city, :website, :email
    )
  end
end
