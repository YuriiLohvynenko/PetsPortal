class Comment < ApplicationRecord
  attr_accessor :community_id
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable
  has_many :likes, as: :likeable, dependent: :destroy
  has_noticed_notifications
  validate_prohibited_words :content
  validates :content, presence: true

  def root_commentable_type
    if commentable_type == "Comment"
      parent_comment = Comment.find(commentable_id)
      parent_comment.root_commentable_type
    else
      commentable_type
    end
  end
end
