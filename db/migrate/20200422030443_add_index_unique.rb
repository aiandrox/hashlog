class AddIndexUnique < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :twitter_id, :string
    add_column :users, :twitter_id, :bigint
    remove_column :tweets, :tweet_id, :string
    add_column :tweets, :tweet_id, :bigint
  end
end
