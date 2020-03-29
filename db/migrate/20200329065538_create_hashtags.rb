class CreateHashtags < ActiveRecord::Migration[5.2]
  def change
    create_table :hashtags do |t|
      t.string  :name, null: false, unique: true
      t.timestamps
    end
  end
end
