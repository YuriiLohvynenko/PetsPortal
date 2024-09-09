class RenameCategoryColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :questions, :category, :special_category
  end
end
