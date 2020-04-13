class Mypage::TagsController < Mypage::BaseController
  def new
    @tag = Tag.new
  end

  def create
    if current_user.create_registered_tag(tag_params[:name])
      redirect_to mypage_path, notice: t('messages.created', item: Tag.model_name.human)
    else
      flash.now[:alert] = t('messages.not_created', item: Tag.model_name.human)
      render :new
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
