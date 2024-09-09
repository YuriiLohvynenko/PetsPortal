class Message < ApplicationRecord
    belongs_to :sender, class_name: 'User', optional: true
    belongs_to :receiver, class_name: 'User'
    scope :unread, -> { where(read: false) }
    validate_prohibited_words :text
end
