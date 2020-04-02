class Mypage::TagsController < ApplicationController
  def new
    @tag = current_user.tags.new
    @registered_tag = current_user.registered_tags.new
  end

  def create
    if create_registered_tag
      redirect_to mypage_path, notice: "#{@tag.name}を登録しました"
    else
      flash.now[:alert] = '登録できませんでした'
      render :new
    end
  end

  private

  def create_registered_tag
    ActiveRecord::Base.transaction do
      @tag = Tag.find_or_create_by!(tag_params)
      @registered_tag = current_user.registered_tags.create!(tag_id: @tag.id)
    rescue ActiveRecord::RecordInvalid
      false
    rescue
      render status: 500
    end
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
