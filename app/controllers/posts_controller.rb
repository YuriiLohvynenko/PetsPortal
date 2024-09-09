class PostsController < ApplicationController
  include CommunitiesHelper
  before_action :authenticate_user_or_admin!
    def new
      @community = Community.find(params[:community_id])
      if community_member(@community) || current_user == @community.admin
        @post = @community.posts.build
      else
        redirect_to community_path(@community)
      end
    end

    def create
      @community = Community.find(params[:community_id])
      @post = @community.posts.build(post_params)
      @post.user = current_user
      if @post.save
        PostNotification.with(post: @post).deliver(@community.members.reject { |recipient| recipient == current_user })
        if current_user != @community.admin
          PostNotification.with(post: @post).deliver(@community.admin)
        end
        flash[:success] = "Post created!"
        redirect_to community_post_path(@community, @post)
      else
        render 'new'
      end
    end

    def show
      @community = Community.find(params[:community_id])
      @post = @community.posts.find(params[:id])
      @comments = @post.comments.order(:created_at).paginate(page: params[:page], per_page: 10)
      @comment = @community.posts.new
      @user = User.with_deleted.find_by(id: @post.user_id)
    end

    def index
      @community = Community.find(params[:community_id])
      @post = @community.posts.build
      @posts = @community.posts.order(created_at: :desc).paginate(page: params[:page], per_page: 20)
      @comment = @community.posts.new
    end

    def edit
      @community = Community.find(params[:community_id])
      @post = @community.posts.find(params[:id])
    end

    def update
      @community = Community.find(params[:community_id])
      @post = @community.posts.find(params[:id])
      if @post.update(post_params)
        flash[:success] = "Post updated!"
        redirect_to community_post_path(@community, @post)
      else
        render 'edit'
      end
    end

    def destroy
      @community = Community.find(params[:community_id])
      @post = @community.posts.find(params[:id])
      @post.destroy
      flash[:success] = "Post deleted!"
      redirect_to community_path(@community)
    end


    def all_posts
      @categories = Category.all
      if params[:category].present?
        category = Category.find(params[:category])
        @posts = Post.joins(:community).where(communities: { category_id: category.id }).paginate(page: params[:page], per_page: 20)
      else
        @posts = Post.all.paginate(page: params[:page], per_page: 20)
      end
    end





    def my_posts
      @posts = current_user.posts
    end

    def edit_post_image
      @post = Post.find(params[:id])
    end

    private

    def post_params
      params.require(:post).permit(:title, :body, :image, :background_image)
    end
  end
