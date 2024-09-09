class CreatePets < ActiveRecord::Migration[6.1]
  def change
    create_table :pets do |t|
      t.string :name
      t.string :type
      t.integer :age
      t.string :gender
      t.string :location
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
