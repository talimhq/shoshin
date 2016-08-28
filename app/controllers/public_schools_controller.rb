class PublicSchoolsController < ApplicationController
  def new
    @school = School.new
  end

  def create
    @school = School.new(school_params)
    if @school.save
      flash[:notice] = 'Établissement ajouté'
      redirect_to new_account_registration_path
    else
      render :new
    end
  end

  private

  def school_params
    params.require(:school).permit(:name, :identifier, :country, :state, :city, :website, :email)
  end
end
