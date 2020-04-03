class UsersController < ApplicationController
  def show
    @user = User.find_by!(uuid: params[:uuid])
  end
end
