class Teacher::StudentPasswordsController < TeacherController
  before_action :authorize

  def update
    if @student.account.update(password: '123456')
      flash[:notice] = 'Le mot de passe de l\'élève a été changé.'
    else
      flash[:notice] = 'Le mot de passe n\'a pas pu être modifié.'
    end
  end

  private

  def authorize
    @student = Student.find(params[:id])
    redirect_to root_url unless current_user.in? @student.classroom.school.teachers
  end
end
