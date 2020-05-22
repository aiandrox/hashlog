class Api::V1::TagsController < Api::V1::BaseController
  def index
    @pagy, tags = pagy(Tag.all)
    render json: tags
  end
end
