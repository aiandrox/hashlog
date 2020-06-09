class StaticPagesController < ApplicationController
  def top; end

  def routing_error
    render :top, status: :not_found
  end
end
