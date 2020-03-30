class RenameUserHashtagsToHashtagUsers < ActiveRecord::Migration[5.2]
  def change
    rename_table :user_hashtags, :hashtag_users
  end
end
