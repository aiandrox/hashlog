class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  protected

  def not_authenticated
    redirect_to root_path, alert: 'ログインしてください'
  end
end
