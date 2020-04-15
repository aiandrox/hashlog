class Api::V1::MypagesController < ApplicationController
  def show
    user = current_user
    registered_tags = user.registered_tags.joins(:tag).select('registered_tags.id, name, tweeted_day_count, privacy, remind_day, first_tweeted_at, last_tweeted_at')
    result_values = {
      user: user,
      registered_tags: registered_tags
    }
    render json: result_values
  end
end
