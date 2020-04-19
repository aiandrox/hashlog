class RegisteredTagsController < ApplicationController
  def show
    @user = User.find_by!(uuid: params[:user_uuid])
    @registered_tag = @user.registered_tags.find(params[:id])
    @tweets = @registered_tag.tweets
  end
end
