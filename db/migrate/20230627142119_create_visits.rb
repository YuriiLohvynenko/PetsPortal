class CreateVisits < ActiveRecord::Migration[6.1]
  def change
    create_table :visits do |t|
      t.integer :visitor_id
      t.integer :visited_id

      t.timestamps
    end
  end
end
