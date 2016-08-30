class Teacher::ClassroomsController < TeacherController
  before_action :authorize_based_on_classroom, only: [:show, :edit, :update,
                                                      :destroy]
  before_action :authorize_based_on_school, only: [:new, :create]

  def show
    @classroom = Classroom.find(params[:id])
  end

  def new
    @classroom = @school.classrooms.new
  end

  def create
    @classroom = @school.classrooms.new(classroom_params)
    if @classroom.save
      flash[:notice] = 'Classe ajoutée.'
      redirect_to [:teacher, @classroom]
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @classroom.update(classroom_params)
      flash[:notice] = 'Classe mise à jour.'
      redirect_to [:teacher, @classroom]
    else
      render :edit
    end
  end

  def destroy
    if @classroom.students.any?
      flash.now[:notice] = 'Vous ne pouvez pas supprimer une classe qui contient des élèves.'
    else
      @classroom.destroy
      flash.now[:notice] = 'Classe supprimée.'
    end
  end

  private

  def classroom_params
    params.require(:classroom).permit(:name, :level_id)
  end

  def authorize_based_on_classroom
    @classroom = Classroom.includes(:level, :students, school: :teachers)
                          .find(params[:id])
    redirect_to root_url unless current_user.in? @classroom.school.teachers
  end

  def authorize_based_on_school
    @school = School.find(params[:school_id])
    redirect_to root_url unless current_user.in? @school.teachers
  end
end
