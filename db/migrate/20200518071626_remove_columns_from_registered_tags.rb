class RemoveColumnsFromRegisteredTags < ActiveRecord::Migration[5.2]
  def change
    remove_column :registered_tags, :last_tweeted_at, :datetime
    remove_column :registered_tags, :tweeted_day_count, :integer
  end
end
