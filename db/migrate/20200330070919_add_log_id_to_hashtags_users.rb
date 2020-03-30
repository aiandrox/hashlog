class AddLogIdToHashtagsUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :hashtags_users, :hashtag_logs, foreign_key: true
  end
end
