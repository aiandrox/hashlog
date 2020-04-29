class StaticPagesController < ApplicationController
  def top
    # TODO: ページ遷移時にリクエストを送ったらいける？
    @page_title = params[:page_title]
  end

  def privacy; end

  def terms; end
end
