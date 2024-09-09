class AddPickedToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_column :answers, :picked, :boolean
  end
end
