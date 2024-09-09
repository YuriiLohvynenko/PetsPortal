class CreateFriendships < ActiveRecord::Migration[6.1]
  def change
    create_table :friendships do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :friend, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :friendships, [:user_id, :friend_id], unique: true
  end
end
