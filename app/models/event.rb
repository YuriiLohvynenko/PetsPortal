class Event < ApplicationRecord
  belongs_to :user
  belongs_to :community
  has_one_attached :image
  has_one_attached :background_image
  has_many :comments, as: :commentable
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :favorites, as: :favorable, dependent: :destroy
  has_many :joining_users, through: :likes, source: :user
  has_noticed_notifications
  validates :image, attached: true, content_type: ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/tiff']
  validates :background_image, content_type: ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/tiff']
  validate_prohibited_words :title, :details
  validates_presence_of :title, :details

  def self.search(query, start_date, end_date, place, order_by)
    events = Event.all

    # Apply query filter
    events = events.where("LOWER(title) LIKE ?", "%#{query.downcase}%") if query.present?

    # Apply start_date filter
    events = events.where("event_date >= ?", start_date) if start_date.present?

    # Apply end_date filter
    events = events.where("event_date <= ?", end_date) if end_date.present?

    # Apply place filter
    events = events.where("LOWER(event_place) LIKE ?", "%#{place.downcase}%") if place.present?

    # Apply order filter
    if order_by.present?
      case order_by
      when "updated_date"
        events = events.order(updated_at: :desc)
      when "event_date"
        events = events.order(event_date: :asc)
      when "participants"
        events = events.to_a.sort_by { |event| -event.joining_users.count }
      else
        events = events.order(created_at: :desc)
      end
    else
      events = events.order(created_at: :desc)
    end

    events
  end

end
