# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Category.destroy_all

categories = [
  { id: 1, name: '犬' },
  { id: 2, name: '猫' },
  { id: 3, name: 'その他' }
]

categories.each do |category|
  @category = Category.create(category)

  case @category.name
  when '犬'
    subcategories = [
      { name: '小型犬' },
      { name: '中型犬' },
      { name: '大型犬' }
    ]
  when '猫'
    subcategories = [
      { name: '短毛種' },
      { name: '長毛種' },
      { name: '短毛種・長毛種' }
    ]
  when 'その他'
    subcategories = [
      { name: '小動物' },
      { name: '観賞魚' },
      { name: '鳥' },
      { name: '爬虫類&両生類' },
      { name: '昆虫' },
      { name: 'その他' }
    ]
  end

  subcategories.each do |subcategory|
    @category.subcategories.create(subcategory)
  end
end


Admin.destroy_all
admins = [
    {id: 1, email: "admin@gmail.com", password: "admin@123"}
]

admins.each do |admin|
    Admin.create(admin)
end
