class CreateAdminMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_messages do |t|
      t.text :content
      t.timestamps
    end
  end
end
