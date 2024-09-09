# To deliver this notification:
#
# PostNotification.with(post: @post).deliver_later(current_user)
# PostNotification.with(post: @post).deliver(current_user)

class PostNotification < Noticed::Base
  include ApplicationHelper
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  param :post

  # Define helper methods to make rendering easier.
  #

  def initialize(params)
    super
    @post = params[:post]
    @community = @post.community
    @user = User.with_deleted.find_by(id: @post.user_id)
  end

  def message
    "#{display_pet_or_username(@user)}が#{@community.title}にトピックを作成しました。"
  end

  def url
    community_post_path(@community, @post)
  end
end
