class Api::V1::Mypage::RegisteredTagsController < Api::V1::Mypage::BaseController
  def show
    registered_tag = current_user.registered_tags.find(params[:id])
    tweets = registered_tag.tweets
    result_values = {
      registered_tags: registered_tag,
      tweets: tweets
    }
    render json: result_values
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

  def tag_params
    params.require(:registered_tag).permit(:privacy, :remind_day)
  end
end
