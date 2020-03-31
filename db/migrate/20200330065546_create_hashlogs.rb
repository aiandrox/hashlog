class CreateHashlogs < ActiveRecord::Migration[5.2]
  def change
    create_table :tag_logs do |t|
      t.integer :tweeted_day_count, null: false, default: 0
      t.integer :privacy, null: false, default: 0 
      t.integer :remind_day, null: false, default: 0
      t.references :user, foreign_key: true, null: false
      t.datetime :last_tweeted_at
      t.timestamps
    end
  end
end
