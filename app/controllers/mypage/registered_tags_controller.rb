class Mypage::RegisteredTagsController < Mypage::BaseController
  before_action :set_tag, only: %i[show edit update destroy]

  def show
    @user = current_user
  end

  def edit; end

  def update
    if @tag.update(tag_params)
      redirect_to mypage_registered_tag_path,
                  notice: t('messages.updated', item: @tag_i18n)
    else
      flash.now[:alert] = t('messages.not_updated', item: @tag_i18n)
      render :edit
    end
  end

  def destroy
    @tag.destroy!
    redirect_to mypage_path, notice: t('messages.updated', item: @tag_i18n)
  end

  private

  def set_tag
    @tag = current_user.registered_tags.find(params[:id])
    @tag_i18n = @tag.model_name.human
  end

  def tag_params
    params.require(:registered_tag).permit(:privacy, :remind_day)
  end
end
