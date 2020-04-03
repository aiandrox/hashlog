class RegisteredTagsController < ApplicationController
  def show
    @user = User.find_by!(uuid: params[:user_uuid])
    @tag = RegisteredTag.find(params[:id])
  end
end
