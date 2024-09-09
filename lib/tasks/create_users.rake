namespace :user do
  desc "Create 100 users"
  task create_100: :environment do
    start_time = Time.now
    100.times do |i|
      User.create!(
        email: Faker::Internet.unique.email,
        password: 'password123',
        password_confirmation: 'password123',
        name: Faker::Name.name,
        age: rand(18..99),
        username: Faker::Internet.unique.username,
        prefecture: Faker::Address.state,
        city: Faker::Address.city,
        additional_info_completed: [true, false].sample,
        own_pet: [true, false].sample
      )
    end
    end_time = Time.now
    puts "100 users created successfully in #{end_time - start_time} seconds!"
  end

  desc "Create 100 users"
  task create_100_skip_email: :environment do
    start_time = Time.now
    100.times do |i|
      user = User.new(
        email: Faker::Internet.unique.email,
        password: 'password123',
        password_confirmation: 'password123',
        name: Faker::Name.name,
        age: rand(18..99),
        username: Faker::Internet.unique.username,
        prefecture: Faker::Address.state,
        city: Faker::Address.city,
        additional_info_completed: [true, false].sample,
        own_pet: [true, false].sample
      )
      user.skip_confirmation!  # メール認証をスキップ
      user.save!
    end
    end_time = Time.now
    puts "100 users created successfully in #{end_time - start_time} seconds!"
  end

  desc "Create 10,000 users"
  task create_10000: :environment do
    start_time = Time.now
    10_000.times do |i|
      User.create!(
        email: Faker::Internet.unique.email,
        password: 'password123',
        password_confirmation: 'password123',
        name: Faker::Name.name,
        age: rand(18..99),
        username: Faker::Internet.unique.username,
        prefecture: Faker::Address.state,
        city: Faker::Address.city,
        additional_info_completed: [true, false].sample,
        own_pet: [true, false].sample
      )
    end
    end_time = Time.now
    puts "10,000 users created successfully in #{end_time - start_time} seconds!"
  end
end
