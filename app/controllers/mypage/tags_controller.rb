class Mypage::TagsController < Mypage::BaseController
  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.find_or_initialize_by(tag_params)
    if current_user.create_registered_tag(@tag)
      redirect_to mypage_path, notice: t('messages.created', item: @tag.model_name.human)
    else
      flash.now[:alert] = t('messages.not_created', item: @tag.model_name.human)
      render :new
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
