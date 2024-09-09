class Visit < ApplicationRecord
    belongs_to :visitor, class_name: 'User', optional: true
    belongs_to :visited, class_name: 'User'
    scope :unread, -> { where(read: false) }
    scope :with_active_visitor, -> { joins(:visitor).where(users: { deleted_at: nil }) }
end
