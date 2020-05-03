class StaticPagesController < ApplicationController
  def top
    @page_title = params[:page_title]
  end

  def mypage
    @page_title = 'マイページ'
    render 'static_pages/top'
  end

  def privacy; end

  def terms; end
end
