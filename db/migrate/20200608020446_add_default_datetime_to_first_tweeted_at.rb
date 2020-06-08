class AddDefaultDatetimeToFirstTweetedAt < ActiveRecord::Migration[5.2]
  def change
    change_column_default :registered_tags, :first_tweeted_at, from: nil, to: Time.parse('2999-12-31')
  end
end
