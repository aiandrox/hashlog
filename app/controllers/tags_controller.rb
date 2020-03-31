class TagsController < ApplicationController
  def new
    @tag = current_user.tags.new
  end

  def create
    if (@tag = current_user.tags.create(name: tag_params[:name]))
      @tag.tag_logs.create!(user_id: current_user)
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
