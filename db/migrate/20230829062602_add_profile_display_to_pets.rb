class AddProfileDisplayToPets < ActiveRecord::Migration[6.1]
  def change
    add_column :pets, :profile_display, :boolean
  end
end
