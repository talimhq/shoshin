class Teacher::ChaptersController < TeacherController
  before_action :authorize_on_group, only: [:new, :create, :sort]
  before_action :authorize_on_chapter, except: [:new, :create, :sort]

  def show
  end

  def new
    @chapter = @group.chapters.new
  end

  def create
    @chapter = @group.chapters.new(chapter_params)
    if @chapter.save
      flash[:notice] = 'Chapitre créé.'
      redirect_to [:teacher, @chapter]
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @chapter.update(chapter_params)
      flash[:notice] = 'Chapitre mis à jour.'
      redirect_to [:teacher, @chapter]
    else
      render :edit
    end
  end

  def destroy
    @chapter.destroy
    flash[:notice] = 'Chapitre supprimé.'
    redirect_to [:teacher, @chapter.group]
  end

  def sort
    params[:chapter].each_with_index do |id, index|
      @group.chapters.find(id).update(position: index + 1)
    end
    head :ok
  end

  private

  def chapter_params
    params.require(:chapter).permit(:name)
  end

  def authorize_on_group
    @group = Group.includes(:teacher).find(params[:group_id])
    redirect_to root_url unless current_user == @group.teacher
  end

  def authorize_on_chapter
    @chapter = Chapter.includes(group: :teacher).find(params[:id])
    redirect_to root_url unless current_user == @chapter.group.teacher
  end
end
