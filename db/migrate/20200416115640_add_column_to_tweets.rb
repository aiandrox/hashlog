class AddColumnToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :tweet_id, :string, null: false
  end
end
