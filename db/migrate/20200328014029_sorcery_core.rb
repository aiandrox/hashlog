class SorceryCore < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :crypted_password
      t.string :salt
      t.string :twitter_id, null: false, unique: true
      t.string :uuid, null: false, unique: true
      t.string :screen_name, null: false
      t.string :email, unique: true
      t.text :description
      t.integer :privacy, null: false, default: 0
      t.integer :role, null: false, default: 1
      t.timestamps                null: false
    end

    add_index :users, :email, unique: true
  end
end
