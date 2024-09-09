module ApplicationHelper
  def display_content_details(content)
    return content.description if content.is_a?(Community)
    return content.body if content.is_a?(Post)
    return content.details if content.is_a?(Event)
  end

  def display_pet_image(user)
    return asset_path('profile.jpg') unless user

    displayed_pet = user.pets.find_by(profile_display: true) || user.pets.first

    if displayed_pet && displayed_pet.image.attached?
      url_for(displayed_pet.image)
    else
      asset_path('profile.jpg')
    end
  end

  def display_pet_or_username(user, fallback_pet_name = nil)
    return fallback_pet_name unless user

    displayed_user = user.deleted_at ? User.with_deleted.find_by(id: user.id) : user
    displayed_pet = displayed_user.pets.find_by(profile_display: true) || displayed_user.pets.first

    displayed_pet ? displayed_pet.name : displayed_user.username
  end

end
