class ChangeCategoryToCategoryIdInCommunities < ActiveRecord::Migration[6.1]
  def change
    # categoryカラムを削除
    remove_column :communities, :category, :string

    # category_idカラムを追加
    add_column :communities, :category_id, :integer

    # category_idカラムに外部キー制約を追加
    add_foreign_key :communities, :categories
  end
end
