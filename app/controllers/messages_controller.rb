class MessagesController < ApplicationController
    before_action :authenticate_user_or_admin!
    before_action :valid_user, only: [:show]

    def show
        @sender = current_user
        @receiver = User.with_deleted.find(params[:id])
        @messages = Message.where(sender_id: @sender.id, receiver_id: @receiver.id).or(Message.where(sender_id: @receiver.id, receiver_id: @sender.id))
        @received_messages = Message.where(sender_id: @receiver.id, receiver_id: @sender.id)
        @received_messages.where(read: false).update_all(read: true)
        @chat_id = [@sender.id, @receiver.id].sort.join("") #generates a unique identifier for a pair of user
    end

    def create
        message = Message.new(sender_id: params[:sender_id], receiver_id: params[:receiver_id], text: params[:message])
        if message.save
            SendMessageJob.perform_later(message)
            redirect_to "/messages/#{message.receiver_id}"
        else
            flash[:errors] = message.errors.full_messages
            redirect_to "/messages/#{message.receiver_id}"
        end
    end

    def index

    end

    def mark_as_read
        message = Message.find(params[:id])
        message.update(read: true)
        redirect_back(fallback_location: messages_path)
    end


    private
    def valid_user
        @user = User.find(params[:id])
        redirect_to root_path unless current_user.friends.include?(@user)
    end
end
