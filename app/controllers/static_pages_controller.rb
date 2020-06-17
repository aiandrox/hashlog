class StaticPagesController < ApplicationController
  def top; end

  def routing_error
    render :top, formats: :html, status: :not_found
  end
end
