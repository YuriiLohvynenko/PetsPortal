class Diary < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :comments, as: :commentable
  has_many :likes, as: :likeable, dependent: :destroy
  validates :image, content_type: ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/tiff']
  validate_prohibited_words :title, :content

end
