class AddLogIdToHashtagsUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :tag_users, :tag_log, foreign_key: true
  end
end
