class Mypage::TagsController < Mypage::BaseController
  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.find_or_initialize_by(name: tag_params[:name]) # tag = が重複しているが、今後捨てる予定なので気にしない
    if current_user.register_tag(@tag.name)
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
