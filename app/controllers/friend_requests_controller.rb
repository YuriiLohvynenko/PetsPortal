class FriendRequestsController < ApplicationController
    before_action :set_friend_request, only: [:accept, :reject]
    before_action :check_existing_request, only: [:create]
    before_action :check_existing_friendship, only: [:create]

    def create
      @friend_request = current_user.sent_friend_requests.build(friend_request_params)

      if @friend_request.save
        redirect_to friendrequest_sent_path(@friend_request.recipient_id)
      else
        redirect_to users_path
      end
    end

    def accept
      @friend_request.accept
      @friend_request.destroy
      redirect_back(fallback_location: root_path)
    end

    def reject
      @friend_request.reject
      @friend_request.destroy
      redirect_back(fallback_location: root_path)
    end

    def sent
      @user = User.find(params[:id])
    end

    private

    def set_friend_request
      @friend_request = FriendRequest.find(params[:id])
    end

    def friend_request_params
      params.require(:friend_request).permit(:recipient_id)
    end

    def check_existing_request
      if current_user.sent_friend_requests.where(recipient_id: friend_request_params[:recipient_id]).exists? ||
         current_user.received_friend_requests.where(sender_id: friend_request_params[:recipient_id]).exists?
        redirect_to root_path
      end
    end

    def check_existing_friendship
      if current_user.friendships.where(friend_id: friend_request_params[:recipient_id]).exists?
        redirect_to root_path
      end
    end
  end
