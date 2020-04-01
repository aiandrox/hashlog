class AddColumnsToRegisteredTags < ActiveRecord::Migration[5.2]
  def change
    add_column :registered_tags, :tweeted_day_count, :integer, null: false, default: 0
    add_column :registered_tags, :privacy, :integer, null: false, default: 0
    add_column :registered_tags, :remind_day, :integer, null: false, default: 0
    add_column :registered_tags, :first_tweeted_at, :datetime
    add_column :registered_tags, :last_tweeted_at, :datetime
  end
end
