class AddAvatarUrlToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :avatar_url, :string, null: false, default: 'https://abs.twimg.com/sticky/default_profile_images/default_profile.png'
  end
end
