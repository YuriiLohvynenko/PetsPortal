class Post < ApplicationRecord
  belongs_to :community
  belongs_to :user
  has_one_attached :image
  has_one_attached :background_image
  has_many :comments, as: :commentable
  has_many :likes, as: :likeable, dependent: :destroy
  has_noticed_notifications
  validates :image, attached: true, content_type: ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/tiff']
  validates :background_image, content_type: ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/tiff']
  validate_prohibited_words :title, :body
  validates_presence_of :title, :body

  # In Post model
  def self.search(query)
    posts = Post.all
    if query.present?
      posts = posts.where("LOWER(title) LIKE ?", "%#{query.downcase}%")
    else
      posts = Post.all
    end

    posts
  end

end
