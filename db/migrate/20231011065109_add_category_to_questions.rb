class AddCategoryToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_reference :questions, :category, index: true, foreign_key: true, null: true
  end
end
