class AddDetailsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :username, :string
    add_column :users, :prefecture, :string
    add_column :users, :city, :string
    add_column :users, :additional_info_completed, :boolean
  end
end
