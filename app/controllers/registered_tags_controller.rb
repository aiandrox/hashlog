class RegisteredTagsController < ApplicationController
  before_action :set_tag, only: %i[edit update]

  def show
    @user = User.find_by!(uuid: params[:user_uuid])
  end

  def edit
  end

  def update
  end

  private

  def set_tag
    @tag = current_user.registered_tags.find(params[:id])
  end
end
