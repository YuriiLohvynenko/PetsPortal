class LikesController < ApplicationController
  
    def create
      @likeable = find_likeable
      @like = @likeable.likes.build(user: current_user)
      @likeable_type = @likeable.class.name.downcase
      community_id = params[:community_id]
      
      if @like.save
        if(@like.user != @likeable.user )
          LikeNotification.with(like: @like, community_id: community_id).deliver(@likeable.user)
        end
        respond_to do |format|
          format.js
        end
      else
        redirect_back(fallback_location: root_path)
      end
    end
  
    def destroy
      @likeable = find_likeable
      @like = @likeable.likes.find_by(user: current_user)
      @likeable_type = @likeable.class.name.downcase
      @like.notifications_as_like.destroy_all
      if @like.destroy
        respond_to do |format|
          format.js
        end
      else
        redirect_back(fallback_location: root_path)
      end
    end
  
    private
    def find_likeable
        if params[:diary_id]
          @likeable = Diary.find_by_id(params[:diary_id])
        elsif params[:post_id]
          @likeable = Post.find_by_id(params[:post_id])
        elsif params[:event_id]
          @likeable = Event.find_by_id(params[:event_id])
        elsif params[:answer_id]
          @likeable = Answer.find_by_id(params[:answer_id])
        elsif params[:comment_id]
          @likeable = Comment.find_by_id(params[:comment_id])
        elsif params[:diary_id]
          @likeable = Diary.find(params[:diary_id])
        end
      end
  end
  