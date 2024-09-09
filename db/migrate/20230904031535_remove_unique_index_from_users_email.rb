class RemoveUniqueIndexFromUsersEmail < ActiveRecord::Migration[6.1]
  def change
    remove_index :users, name: "index_users_on_email"
  end
end
