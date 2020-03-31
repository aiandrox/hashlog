class RemoveUserHashtagsToUsersHashtags < ActiveRecord::Migration[5.2]
  def change
    drop_table :user_hashtags

    create_table :hashtags_users, id: false do |t|
      t.belongs_to :hashtag
      t.belongs_to :user
    end
  end
end
