class CreateCommunities < ActiveRecord::Migration[6.1]
  def change
    create_table :communities do |t|
      t.string :title
      t.string :category
      t.string :description

      t.timestamps
    end
  end
end
