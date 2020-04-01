class RenameTagUsersToRegisteredTags < ActiveRecord::Migration[5.2]
  def change
    rename_table :tag_users, :registered_tags
  end
end
