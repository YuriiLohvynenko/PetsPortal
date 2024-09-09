module PetsHelper
    def pet_owner(pet)
        User.find_by(id: pet.user_id)
    end
end
