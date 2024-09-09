class AddAdminPetNameToCommunities < ActiveRecord::Migration[6.1]
  def change
    add_column :communities, :admin_pet_name, :string
  end
end
