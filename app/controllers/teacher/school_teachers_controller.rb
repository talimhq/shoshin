class Teacher::SchoolTeachersController < TeacherController
  before_action :authorize_new, only: [:new, :create]
  before_action :authorize_destroy, only: :destroy

  def new
    @school_teacher = current_user.build_school_teacher
  end

  def create
    @school_teacher = current_user.build_school_teacher(school_teacher_params)
    if @school_teacher.save
      SchoolTeacherMailer.new_teacher(@school_teacher).deliver_later
      flash[:notice] = 'Demande enregistrée.'
      redirect_to [:teacher, @school_teacher.school]
    else
      flash.now[:notice] = 'Une erreur est survenue.'
      render :new
    end
  end

  def update
    @school_teacher = SchoolTeacher.includes(school: :teachers).find(params[:id])
    if current_user.in? @school_teacher.school.teachers
      @school_teacher.update(approved: true)
      @school_teacher.teacher.update(approved: true)
      redirect_to [:teacher, @school_teacher.school]
    else
      redirect_to root_url
    end
  end

  def destroy
    @school_teacher.destroy
    flash[:notice] = 'Demande supprimée.'
    if current_user == @school_teacher.teacher
      redirect_to new_teacher_school_teacher_path
    else
      redirect_to [:teacher, @school_teacher.school]
    end
  end

  private

  def school_teacher_params
    params.require(:school_teacher).permit(:school_id)
  end

  def authorize_new
    redirect_to root_url if current_user.school
  end

  def authorize_destroy
    @school_teacher = SchoolTeacher.includes(:teacher, school: :teachers).find(params[:id])
   unless current_user.in? @school_teacher.school.teachers + [@school_teacher.teacher]
     redirect_to root_url
   end
  end
end
