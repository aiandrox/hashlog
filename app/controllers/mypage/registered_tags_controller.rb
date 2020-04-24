class Mypage::RegisteredTagsController < Mypage::BaseController
  before_action :set_registered_tag, only: %i[show edit update destroy]

  def show
    @user = current_user
    @tweets = @registered_tag.tweets
  end

  def edit; end

  def update
    if @registered_tag.update(tag_params)
      redirect_to mypage_registered_tag_path,
                  notice: t('messages.updated', item: "#{@registered_tag_i18n}の設定")
    else
      flash.now[:alert] = t('messages.not_updated', item: "#{@registered_tag_i18n}の設定")
      render :edit
    end
  end

  def destroy
    @registered_tag.destroy!
    redirect_to mypage_path, notice: t('messages.deleted', item: @registered_tag_i18n)
  end

  private

  def set_registered_tag
    @registered_tag = current_user.registered_tags.find(params[:id])
    @registered_tag_i18n = @registered_tag.model_name.human
  end

  def tag_params
    params.require(:registered_tag).permit(:privacy, :remind_day)
  end
end
