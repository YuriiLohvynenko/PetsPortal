class SetDeafaultValues < ActiveRecord::Migration[6.1]
  def change
    change_column_default :messages, :read, from: nil, to: false
    change_column_default :visits, :read, from: nil, to: false
  end
end
