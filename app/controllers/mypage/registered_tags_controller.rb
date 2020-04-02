class Mypage::RegisteredTagsController < ApplicationController
  before_action :set_tag, only: %i[show edit update destroy]

  def show
  end

  def edit
  end

  def update
    if @tag.update(tag_params)
      redirect_to mypage_registered_tag_path
    else
      flash.now[:alert] = '更新できませんでした'
      render :edit
    end
  end

  def destroy
    @tag.destroy!
    redirect_to mypage_path
  end

  private

  def set_tag
    @tag = current_user.registered_tags.find(params[:id])
  end

  def tag_params
    params.require(:registered_tag).permit(:privacy, :remind_day)
  end
end
