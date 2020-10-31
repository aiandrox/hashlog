class StaticPagesController < ApplicationController
  before_action :require_login, only: :mypage

  def top; end

  def mypage
    current_user.registered_tags.find(params[:id])
    render :top, formats: :html
  end

  def routing_error
    render :top, formats: :html, status: :not_found
  end
end
