class Mypage::RegisteredTagsController < ApplicationController
  before_action :set_tag, only: %i[show edit update]

  def show
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
