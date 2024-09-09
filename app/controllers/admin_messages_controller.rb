class AdminMessagesController < ApplicationController
    before_action :authenticate_admin!, except: [:index]
    def index
        @admin_messages = AdminMessage.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
    end

    def create
        @admin_message = AdminMessage.new(admin_message_params)

        ActiveRecord::Base.transaction do
            @admin_message.save!

            notifications = []
            User.find_each do |user|
            notifications << Notification.new(
                recipient: user,
                type: 'AdminMessageNotification',
                params: { admin_message_id: @admin_message.id }
            )
            end
            Notification.import notifications

            redirect_to admin_notifications_path, notice: 'メッセージと通知が正常に作成されました'
        end

        rescue ActiveRecord::RecordInvalid => e
        flash[:alert] = 'メッセージの作成に失敗しました'
        render :new
        rescue => e
        flash[:alert] = "エラーが発生しました: #{e.message}"
        render :new
    end


    def destroy
        @admin_message = AdminMessage.find(params[:id])
        @admin_message.notifications_as_admin_message.destroy_all
        @admin_message.destroy
        redirect_to admin_notifications_path
    end

    private
    def admin_message_params
        params.require(:admin_message).permit(:content)
    end

end
