# To deliver this notification:
#
# AdminMessageNotification.with(post: @post).deliver_later(current_user)
# AdminMessageNotification.with(post: @post).deliver(current_user)

class AdminMessageNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  param :admin_message

  def initialize(params)
    super
    @admin_message = AdminMessage.find_by(id: params[:admin_message_id])
  end

  def message
    "#{@admin_message.content[0...50]}"
  end

  def url
    admin_messages_path
  end
end
