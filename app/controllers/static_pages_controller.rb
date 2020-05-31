class StaticPagesController < ApplicationController
  def top; end

  def routing_error
    render :top, status: 404
  end
end
