class TagLogsController < ApplicationController
  def edit
    @tag_log = current_user.tag_logs.find(params[:id])
  end

  def update
    @tag_log = current_user.tag_logs.find(params[:id])
  end

  def show
    @user = User.find_by!(uuid: params[:user_uuid])
  end
end
