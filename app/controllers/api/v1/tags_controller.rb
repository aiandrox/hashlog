class Api::V1::TagsController < Api::V1::BaseController
  def index
    if (count = params[:count])
      tags = Tag.popular.limit(count)
    else
      @pagy, tags = pagy(Tag.popular)
    end
    render json: tags
  end
end
