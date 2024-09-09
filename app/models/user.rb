class User < ApplicationRecord
  acts_as_paranoid
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :timeoutable

  has_many :pets
  has_many :diaries
  has_many :comments
  has_many :sent_friend_requests, foreign_key: :sender_id, class_name: 'FriendRequest'
  has_many :received_friend_requests, foreign_key: :recipient_id, class_name: 'FriendRequest'
  has_many :friendships
  has_many :friends, through: :friendships
  has_many :messagee, foreign_key: :receiver_id, class_name: 'Message'
  has_many :senders, through: :messagee
  has_many :messaged, foreign_key: :sender_id, class_name: 'Message'
  has_many :receivers, through: :messaged
  has_many :communities_administered, class_name: "Community", foreign_key: "admin_id"
  has_many :memberships
  has_many :communities, through: :memberships
  has_many :posts
  has_many :events
  has_many :questions
  has_many :answers
  has_many :likes
  has_many :notifications, as: :recipient
  has_many :visits, foreign_key: :visited_id
  has_many :joined_events, through: :likes, source: :likeable, source_type: 'Event'
  has_many :favorites
  has_many :favorited_events, through: :favorites, source: :favorable, source_type: 'Event'
  validates :email, uniqueness: { conditions: -> { where(deleted_at: nil) } }, if: -> { deleted_at.nil? }

  validates :name,:age, presence: true

  validates :prefecture, :city, presence: true, on: :update

  def likes?(likeable)
    likes.exists?(likeable: likeable)
  end

  def favorites?(favorable)
    favorites.exists?(favorable: favorable)
  end

  def diary_years
    diaries.pluck(Arel.sql('EXTRACT(YEAR FROM created_at)')).map(&:to_i).uniq.sort.reverse
  end

  def has_diary_in?(year, month, day=nil)
    if day
      start_time = Time.zone.local(year, month, day).beginning_of_day
      end_time = Time.zone.local(year, month, day).end_of_day
      diaries.where(created_at: start_time..end_time).exists?
    else
      start_time = Time.zone.local(year, month).beginning_of_month
      end_time = Time.zone.local(year, month).end_of_month
      diaries.where(created_at: start_time..end_time).exists?
    end
  end
end
