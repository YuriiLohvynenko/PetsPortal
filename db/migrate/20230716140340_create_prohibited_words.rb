class CreateProhibitedWords < ActiveRecord::Migration[6.1]
  def change
    create_table :prohibited_words do |t|
      t.string :word
      t.timestamps
    end
  end
end
