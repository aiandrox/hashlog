class ChangeColumnToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :oembed, :text, null: false
    add_column :tweets, :tweeted_at, :datetime, null: false
    remove_column :tweets, :content, :string
    remove_column :tweets, :media_url, :string
  end
end
