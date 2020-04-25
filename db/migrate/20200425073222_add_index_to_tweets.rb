class AddIndexToTweets < ActiveRecord::Migration[5.2]
  def change
    add_index :tweets, [:tweet_id, :registered_tag_id], unique: true
  end
end
