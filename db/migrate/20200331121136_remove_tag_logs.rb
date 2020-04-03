class RemoveTagLogs < ActiveRecord::Migration[5.2]
  def change
    remove_reference :registered_tags, :tag_log, index: true, foreign_key: true
    drop_table :tag_logs
  end
end
