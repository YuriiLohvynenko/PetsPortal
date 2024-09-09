module DiariesHelper
    def diary_owner(diary)
        User.find_by(id: diary.user_id)
    end
end
