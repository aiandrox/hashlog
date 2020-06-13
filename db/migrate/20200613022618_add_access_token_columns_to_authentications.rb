class AddAccessTokenColumnsToAuthentications < ActiveRecord::Migration[5.2]
  def change
    add_column :authentications, :access_token, :string, null: false, default: ''
    add_column :authentications, :access_token_secret, :string, null: false, default: ''
  end
end
