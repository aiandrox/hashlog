class SorceryCore < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :twitter_id, null: false, unique: true
      t.string :uuid, null: false, unique: true
      t.string :name, null: false
      t.text :description
      t.integer :privacy, null: false, default: 0
      t.integer :role, null: false, default: 1
      t.timestamps                null: false
    end

    add_index :users, :twitter_id, unique: true
  end
end
