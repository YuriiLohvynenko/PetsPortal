class Community < ApplicationRecord
    belongs_to :admin, class_name: "User"
    has_many :memberships, dependent: :destroy
    has_many :members, through: :memberships, source: :user
    has_many :posts, dependent: :destroy
    has_many :events, dependent: :destroy
    has_one_attached :image
    has_one_attached :background_image
    validates :image, attached: true, content_type: ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/tiff']
    validates :background_image, content_type: ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/tiff']
    validate_prohibited_words :title, :description
    belongs_to :category
    validates_presence_of :title, :description

    before_save :set_admin_pet_name

    def self.search(query, category, order_by)
        communities = Community.all

        # Apply query filter
        if query.present?
            communities = communities.where("LOWER(title) LIKE ?", "%#{query.downcase}%")
        end

        # Apply category filter
        if category.present?
          communities = communities.where(category_id: category)
        end

        # Apply order filter
        if order_by.present?
          case order_by
          when "updated_date"
            communities = communities.order(updated_at: :desc)
          when "participants"
            communities = communities.sort_by { |community| community.members.count }.reverse
          end
        end

        communities
    end

    def set_admin_pet_name
      displayed_pet = self.admin.pets.find_by(profile_display: true) || self.admin.pets.first
      self.admin_pet_name = displayed_pet.name if displayed_pet
    end

end
