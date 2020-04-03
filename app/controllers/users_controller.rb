class UsersController < ApplicationController
  def show
    @user = User.find_by!(uuid: params[:uuid])
    @registered_tags = @user.registered_tags.includes(:tag)
  end
end
