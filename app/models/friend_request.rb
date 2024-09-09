class FriendRequest < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  scope :pending, -> { where(status: 'pending') }
  scope :accepted, -> { where(status: 'accepted') }
  scope :rejected, -> { where(status: 'rejected') }

  def accept
    update(status: 'accepted')
    Friendship.create(user: sender, friend: recipient)
    Friendship.create(user: recipient, friend: sender)
  end

  def reject
    update(status: 'rejected')
  end
end
