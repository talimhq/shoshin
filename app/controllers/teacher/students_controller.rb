class Teacher::StudentsController < TeacherController
  before_action :authorize_on_school, only: [:new, :create]
  before_action :authorize_on_student, only: [:edit, :update, :destroy]

  def new
    @student = @classroom.students.new
    @student.build_account
  end

  def create
    @student = @classroom.students.new(student_params)
    @student.account.skip_confirmation! if @student.account
    if @student.save
      flash[:notice] = 'Élève ajouté.'
      redirect_to [:teacher, @classroom]
    else
      render :new
    end
  end

  def edit
  end

  def update
    @student.account.skip_reconfirmation!
    if @student.update(student_params)
      flash[:notice] = 'Élève mis à jour.'
      redirect_to [:teacher, @student.classroom]
    else
      render :edit
    end
  end

  def destroy
    @student.destroy
    flash[:notice] = 'Élève supprimé.'
    redirect_to [:teacher, @student.classroom]
  end

  private

  def student_params
    params.require(:student).permit(account_attributes: [
      :id, :first_name, :last_name, :email
    ])
  end

  def authorize_on_school
    @classroom = Classroom.includes(:school ).find(params[:classroom_id])
    redirect_to root_url unless current_user.in? @classroom.school.teachers
  end

  def authorize_on_student
    @student = Student.includes(classroom: :school).find(params[:id])
    redirect_to root_url unless current_user.in? @student.classroom.school.teachers
  end
end
