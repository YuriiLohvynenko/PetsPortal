# To deliver this notification:
#
# CommentNotification.with(post: @post).deliver_later(current_user)
# CommentNotification.with(post: @post).deliver(current_user)

class CommentNotification < Noticed::Base
  include ApplicationHelper
  # Add your delivery methods

  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  param :comment

  # Define helper methods to make rendering easier.

  def initialize(params)
    super
    @comment = params[:comment]
    @community_id = params[:community_id]
    @commentable = @comment.commentable
    @user = @comment.user
    @user = User.with_deleted.find_by(id: @comment.user_id)
  end

  def message
    if @commentable.is_a?(Post)
      "#{display_pet_or_username(@user)}があなたのトピックにコメントしました。"
    elsif @commentable.is_a?(Comment)
      "#{display_pet_or_username(@user)}があなたのコメントに返信しました。"
    elsif @commentable.is_a?(Event)
      "#{display_pet_or_username(@user)}があなたのイベントにコメントしました。"
    else
      "#{display_pet_or_username(@user)}があなたの投稿にコメントしました。"
    end
  end

  def url
    if @commentable.is_a?(Post)
      community_post_path(@commentable.community, @commentable)
    elsif @commentable.is_a?(Comment)
      if @community_id
        comment_path(@community_id, @commentable)
      else
        comment_path(@commentable)
      end
    elsif @commentable.is_a?(Event)
      community_event_path(@commentable.community, @commentable)
    else
      "#"
    end
  end

end
