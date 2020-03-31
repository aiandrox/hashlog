class HashtagsController < ApplicationController
  def new
    @hashtag = current_user.hashtags.new
  end

  def create
    if (@hashtag = current_user.hashtags.create(name: hashtag_params[:name]))
      @hashtag.hashtag_logs.create!(user_id: current_user)
      redirect_to mypage_path(current_user.uuid)
    else
      flash.now[:alert] = '登録できませんでした'
      render :new
    end
  end

  private

  def hashtag_params
    params.require(:hashtag).permit(:name)
  end
end
