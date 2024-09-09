class UpdateEmailIndexOnUsers < ActiveRecord::Migration[6.1]
  def change
    unless index_exists?(:users, :email, name: "index_users_on_email")
      add_index :users, :email, unique: true, where: 'deleted_at IS NULL'
    end
  end
end
