class Admin::LevelsController < AdminController
  def sort
    params[:level].each_with_index do |id, index|
      Level.find(id).update(position: (index + 1))
    end
    head :ok
  end
end
