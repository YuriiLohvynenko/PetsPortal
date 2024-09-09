class Pet < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  belongs_to :category
  belongs_to :subcategory
  validates :image, attached: true, content_type: ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/tiff']
  validate_prohibited_words :name

  before_create :set_default_display_pet

  def self.search(category, subcategory, prefecture, city, free_words)
    pets = self.all
    pets = pets.where(category_id: category) if category.present?
    pets = pets.where(subcategory_id: subcategory) if subcategory.present?
    pets = pets.joins(:user).where(users: { prefecture: prefecture }) if prefecture.present?
    pets = pets.joins(:user).where(users: { city: city }) if city.present?
    pets = pets.where("pets.name LIKE ?", "%#{free_words}%") if free_words.present?
    pets
  end

  def set_default_display_pet
    unless user.pets.exists?
      self.profile_display = true
    end
  end
end
