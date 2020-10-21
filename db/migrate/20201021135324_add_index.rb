class AddIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :registered_tags, [:user_id, :tag_id], unique: true
    add_index :tweets, :tweeted_at
    add_index :registered_tags, :created_at
  end
end
