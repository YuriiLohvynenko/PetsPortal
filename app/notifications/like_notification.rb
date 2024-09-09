class LikeNotification < Noticed::Base
  include ApplicationHelper
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  param :like

  # Define helper methods to make rendering easier.
  #

  def initialize(params)
    super
    @like = params[:like]
    @community_id = params[:community_id]
    @likeable = @like.likeable
    @user = User.with_deleted.find_by(id: @like.user_id)
  end

  def message
    if @likeable.is_a?(Post)
      "#{display_pet_or_username(@user)}があなたの投稿にいいねをしました。"
    elsif @likeable.is_a?(Comment)
      "#{display_pet_or_username(@user)}があなたのコメントにいいねをしました。"
    elsif @likeable.is_a?(Event)
      "#{display_pet_or_username(@user)}があなたのイベントに参加しました。"
    elsif @likeable.is_a?(Answer)
      "#{display_pet_or_username(@user)}があなたの回答にいいねをしました。"
    elsif @likeable.is_a?(Diary)
      "#{display_pet_or_username(@user)}があなたの日記にいいねをしました。"
    else
      "#{display_pet_or_username(@user)}があなたの投稿にいいねをしました。"
    end
  end

  def url
    if @likeable.is_a?(Post)
      community_post_path(@likeable.community, @likeable)
    elsif @likeable.is_a?(Comment)
      if @community_id
        comment_path(@community_id, @likeable)
      else
        comment_path(@likeable)
      end
    elsif @likeable.is_a?(Event)
      community_event_path(@likeable.community, @likeable)
    elsif @likeable.is_a?(Answer)
      question_path(@likeable.question)
    elsif @likeable.is_a?(Diary)
      user_diary_path(@likeable.user, @likeable)
    else
      "#"
    end
  end
end
