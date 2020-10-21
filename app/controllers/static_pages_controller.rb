class StaticPagesController < ApplicationController
  def top; end

  def mypage
    current_user.tags.find(params[:id])
    render :top, formats: :html
  end

  def routing_error
    render :top, formats: :html, status: :not_found
  end
end
