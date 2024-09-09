class AddAdminIdToCommunities < ActiveRecord::Migration[6.1]
  def change
    add_column :communities, :admin_id, :integer
  end
end
