# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
    before_action :authenticate_user_or_admin!
    before_action :find_commentable

    def create
      @comment = @commentable.comments.new(comment_params)
      @comment.user = current_user
      community_id = params[:comment][:community_id]

      if @comment.save
        if(@comment.user != @commentable.user)
          CommentNotification.with(comment: @comment,  community_id: community_id).deliver(@commentable.user)
        end
        redirect_back(fallback_location: root_path)
      else
        flash[:alert] = 'コメントを入力してください'
        redirect_back(fallback_location: root_path)
      end
    end

    def destroy
      @diary = Diary.find(params[:diary_id])
      @comment = @diary.comments.find(params[:id])

      if @comment.destroy
        redirect_to @diary
      else
        redirect_to @diary
      end
    end

    def show
      @community = Community.find(params[:community_id])
      @comment = Comment.find(params[:id])
      @comments = @comment.comments.paginate(page: params[:page], per_page: 10)
    end

    private

    def find_commentable
      if params[:diary_id]
        @commentable = Diary.find_by_id(params[:diary_id])
      elsif params[:post_id]
        @commentable = Post.find_by_id(params[:post_id])
      elsif params[:event_id]
        @commentable = Event.find_by_id(params[:event_id])
      elsif params[:comment_id]
        @commentable = Comment.find_by_id(params[:comment_id])
      end
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
end
