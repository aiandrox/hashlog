class Development::SessionsController < ActionController::Base
  def login_as
    user = User.find(params[:user_id])
    auto_login(user)
    redirect_to mypage_path, notice: "#{Rails.env}環境でログインしました"
  end
end
