class CreateUserHashtags < ActiveRecord::Migration[5.2]
  def change
    create_table :user_hashtags do |t|
      t.references :user, foreign_key: true
      t.references :hashtag, foreign_key: true

      t.timestamps
    end
  end
end
