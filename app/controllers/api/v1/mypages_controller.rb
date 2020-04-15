class Api::V1::MypagesController < ApplicationController
  def show
    user = current_user
    registered_tags = user.registered_tags
    result_values = {
      user: user,
      registered_tags: registered_tags
    }
    render json: result_values
  end
end
