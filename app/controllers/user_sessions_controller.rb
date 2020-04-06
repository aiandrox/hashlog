class UserSessionsController < ApplicationController
  def destroy
    logout
    redirect_to root_path, notice: t('messages.logged_out')
  end

  def guest_login
    user = User.find_by!(role: :guest)
    auto_login(user)
    redirect_to mypage_path, notice: "ゲストユーザーとして#{t('messages.logged_in')}"
  end
end
