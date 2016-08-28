class Admin::UsersController < AdminController
  def index
    @q = Account.all.ransack(params[:q])
    @users = @q.result.order(last_name: :asc).page(params[:page]).per(10)
  end

  def destroy
    @user = Account.find(params[:id])
    @user.destroy
  end

  def edit
    @user = Account.find(params[:id])
  end

  def update
    @user = Account.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = 'Utilisateur mis à jour'
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:account).permit(
      :first_name, :last_name, :email
    )
  end
end
