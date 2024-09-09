class AddSubcategoryToQuestion < ActiveRecord::Migration[6.1]
  def change
    add_reference :questions, :subcategory, foreign_key: true
  end
end
