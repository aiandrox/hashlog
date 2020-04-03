class Mypage::BaseController < ApplicationController
  before_action :require_login

  protected

  def not_authenticated
    redirect_to root_path, alert: 'ログインしてください'
  end
end
