class MypagesController < ApplicationController
  before_action :set_user

  def show
    @registered_tags = @user.registered_tags.includes(:tag)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to mypage_path, notice: '更新しました'
    else
      flash.now[:alert] = '更新できませんでした'
      render :edit
    end
  end

  def destroy
    @user.destroy!
    redirect_to root_path, notice: 'ユーザーを削除しました'
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :description, :privacy)
  end
end
