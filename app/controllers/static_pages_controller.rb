class StaticPagesController < ApplicationController
  def top; end

  def vue
    render layout: false
  end

  def privacy; end

  def terms; end
end
