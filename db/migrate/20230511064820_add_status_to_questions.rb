class AddStatusToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :status, :string
  end
end
