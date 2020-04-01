class Mypage::TagsController < ApplicationController
  def new
    @tag = current_user.tags.new
  end

  def create
    if (@tag = current_user.tags.find_or_create_by(tag_params))
      current_user.registered_tags.create!(tag_id: @tag.id)
      redirect_to mypage_path(current_user.uuid)
    else
      flash.now[:alert] = '登録できませんでした'
      render :new
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
