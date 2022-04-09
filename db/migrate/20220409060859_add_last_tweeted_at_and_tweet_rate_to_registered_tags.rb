class AddLastTweetedAtAndTweetRateToRegisteredTags < ActiveRecord::Migration[6.1]
  def change
    add_column :registered_tags, :last_tweeted_at, :datetime
    add_column :registered_tags, :tweet_rate, :float, index: true, null: false, default: 0
  end
end
