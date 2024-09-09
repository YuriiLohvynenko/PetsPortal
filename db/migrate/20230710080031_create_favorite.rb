class CreateFavorite < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :favorable, polymorphic: true, null: false
    
      t.timestamps
    end
    add_index :favorites, [:user_id, :favorable_type, :favorable_id], unique: true
  end
end
