class StaticPagesController < ApplicationController
  def top
  end

  def mypage
    render 'static_pages/top'
  end

  def privacy; end

  def terms; end
end
