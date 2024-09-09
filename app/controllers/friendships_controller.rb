class FriendshipsController < ApplicationController
    def create
      @friendship = Friendship.create(user_id: current_user.id, friend_id: params[:friend_id])
      redirect_to users_path
    end

    def destroy
      Friendship.where(user_id: current_user.id, friend_id: params[:id]).or(Friendship.where(user_id: params[:id], friend_id: current_user.id)).destroy_all
      redirect_back(fallback_location: root_path)
    end
end
