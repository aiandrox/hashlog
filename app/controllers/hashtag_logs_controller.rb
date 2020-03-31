class HashtagLogsController < ApplicationController
  def edit
    @hashtag_log = current_user.hashtag_logs.find(params[:id])
  end

  def update
    @hashtag_log = current_user.hashtag_logs.find(params[:id])
  end

  def show
    @user = User.find_by!(uuid: params[:user_uuid])
  end
end
