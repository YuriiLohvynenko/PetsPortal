json.extract! pet, :id, :name, :type, :age, :gender, :location, :user_id, :created_at, :updated_at
json.url pet_url(pet, format: :json)
