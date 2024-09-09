# To deliver this notification:
#
# EventNotification.with(post: @post).deliver_later(current_user)
# EventNotification.with(post: @post).deliver(current_user)

class EventNotification < Noticed::Base
  include ApplicationHelper
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params

  param :event

  def initialize(params)
    super
    @event = params[:event]
    @community = @event.community
    @user = User.with_deleted.find_by(id: @event.user_id)
  end

  def message
    "#{display_pet_or_username(@user)}が#{@community.title}に新しいイベントを作成しました。"
  end

  def url
    community_event_path(@community, @event)
  end
end
