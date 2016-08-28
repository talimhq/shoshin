module Authorization
  extend ActiveSupport::Concern

  included do
    protected

    def restrict_to_admins
      authenticate_account!
      redirect_to root_url unless current_account.user.admin?
    end

    def restrict_to_teachers
      authenticate_account!
      redirect_to root_url unless current_account.role == 'teacher'
    end

    def restrict_to_students
      authenticate_account!
      redirect_to root_url unless current_account.role == 'student'
    end

    def restrict_to_parents
      authenticate_account!
      redirect_to root_url unless current_account.role == 'parent'
    end

    def restrict_to_users
      authenticate_account!
    end

    def restrict_to_guests
      redirect_to root_url if account_signed_in?
    end
  end
end
