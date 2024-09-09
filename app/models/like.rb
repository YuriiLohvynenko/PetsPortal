class Like < ApplicationRecord
    attr_accessor :community_id
    belongs_to :user
    belongs_to :likeable, polymorphic: true
    has_noticed_notifications
end
