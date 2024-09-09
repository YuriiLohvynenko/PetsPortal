module CommunitiesHelper
    def community_owner(community)
        User.find_by(id: community.admin_id)
    end

    def community_member(community)
        Membership.where(community_id: community.id, user_id: current_user.id).exists?
    end
end
