class Teacher::TeacherTeachingCyclesController < TeacherController
  def index
    @user_teaching_cycles = current_user.teacher_teaching_cycles.includes(teaching_cycle: [:teaching, :cycle]).sort_by { |utc| [utc.cycle_name, utc.teaching_name] }
  end

  def create
    teaching_cycle = TeachingCycle.find_by(teacher_teaching_cycle_params)
    if teaching_cycle && current_user.teacher_teaching_cycles.new(teaching_cycle: teaching_cycle).save
      flash[:notice] = 'Référentiel ajouté'
    else
      flash[:notice] = 'Référentiel inexistant ou déjà ajouté'
    end
    redirect_to teacher_teacher_teaching_cycles_path
  end

  def destroy
    @teacher_teaching_cycle = TeacherTeachingCycle.includes(:teacher).find(params[:id])
    @teacher_teaching_cycle.destroy if @teacher_teaching_cycle.teacher == current_user
    redirect_to teacher_teacher_teaching_cycles_path
  end

  private

  def teacher_teaching_cycle_params
    params.require(:teaching_cycle).permit(:teaching_id, :cycle_id)
  end
end
