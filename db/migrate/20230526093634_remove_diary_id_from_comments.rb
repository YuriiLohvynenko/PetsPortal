class RemoveDiaryIdFromComments < ActiveRecord::Migration[6.1]
  def change
    remove_column :comments, :diary_id, :integer
  end
end
