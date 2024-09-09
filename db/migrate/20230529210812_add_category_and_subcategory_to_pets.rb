class AddCategoryAndSubcategoryToPets < ActiveRecord::Migration[6.1]
  def change
    add_reference :pets, :category, null: false, foreign_key: true
    add_reference :pets, :subcategory, null: false, foreign_key: true
  end
end
