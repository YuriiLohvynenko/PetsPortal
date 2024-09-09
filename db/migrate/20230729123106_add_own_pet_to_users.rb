class AddOwnPetToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :own_pet, :boolean
  end
end
