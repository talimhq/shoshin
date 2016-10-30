class Teacher::PreferencesController < TeacherController
  def update
    current_user.update(preferences_params)
    flash[:notice] = 'Préférences mises à jour.'
    redirect_to edit_account_registration_path
  end

  private

  def preferences_params
    params.require(:teacher).permit(preferences: [:level_id, :teaching_id])
  end
end
