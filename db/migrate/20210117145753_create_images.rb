class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.string :alt, null: false
      t.string :src, null: false
      t.references :tweet, foreign_key: true, null: false
    end
  end
end
