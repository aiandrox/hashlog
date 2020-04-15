class MypagesController < ApplicationController
  before_action :require_login
  before_action :set_user

  def show
    @registered_tags = @user.registered_tags.includes(:tag)
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to mypage_path, notice: t('messges.updated', item: @user_i18n)
    else
      flash.now[:alert] = t('messages.not_updated', item: @user_i18n)
      render :edit
    end
  end

  def destroy
    @user.destroy!
    redirect_to root_path, notice: t('messages.deleted', item: @user_i18n)
  end

  private

  def set_user
    @user = current_user
    @user_i18n = @user.model_name.human
  end

  def user_params
    params.require(:user).permit(:name, :description, :privacy)
  end
end
