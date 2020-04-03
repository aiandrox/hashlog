class RegisteredTagsController < ApplicationController
  def show
    @user = User.find_by!(uuid: params[:user_uuid])
  end
end
