class CommunitiesController < ApplicationController
  require 'will_paginate/array'

  before_action :set_community, only: %i[ show edit update destroy ]
  before_action :authenticate_user_or_admin!

  # GET /communities or /communities.json
  def index
    @query = params[:query]
    @category = params[:category]
    @order_by = params[:order_by]

    @communities = Community.search(@query, @category, @order_by)

    @posts = Post.order(created_at: :desc)
    @events = Event.order(created_at: :desc)
    @all_content = (@communities + @posts + @events).sort_by(&:created_at).reverse
  end


  # GET /communities/1 or /communities/1.json
  def show
    @community_membership =  Membership.where(community_id: @community.id, user_id: current_user.id).first
    @membership = @community.memberships.new
  end

  # GET /communities/new
  def new
    @community = Community.new
  end

  # GET /communities/1/edit
  def edit
  end

  # POST /communities or /communities.json
  def create
    @community = Community.new(community_params)
    @community.admin = current_user

    respond_to do |format|
      if @community.save
        format.html { redirect_to community_url(@community) }
        format.json { render :show, status: :created, location: @community }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @community.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /communities/1 or /communities/1.json
  def update
    respond_to do |format|
      if @community.update(community_params)
        format.html { redirect_to community_url(@community) }
        format.json { render :show, status: :ok, location: @community }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @community.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /communities/1 or /communities/1.json
  def destroy
    @community.destroy

    respond_to do |format|
      format.html { redirect_to communities_url }
      format.json { head :no_content }
    end
  end

  def search
    @community = Community.find(params[:id])
    @search_type = params[:search_type]
    query = params[:query]
    per_page = 10 # 1ページあたりの項目数
    combined_results = []

    case @search_type
    when "all"
      # Search in posts by title and body
      posts_title_body = @community.posts.where("posts.title LIKE ? OR posts.body LIKE ?", "%#{query}%", "%#{query}%")

      # Search in posts by comments
      posts_comments = @community.posts.joins(:comments).where("comments.content LIKE ?", "%#{query}%").distinct

      @events = @community.events.where("title LIKE ? OR details LIKE ?", "%#{query}%", "%#{query}%")

      combined_results = (posts_title_body + posts_comments + @events).uniq
      @paginated_results = combined_results.sort_by(&:created_at).reverse.paginate(page: params[:page], per_page: per_page)

    when "topic"
        # Search in posts by title and body
        posts_title_body = @community.posts.where("posts.title LIKE ? OR posts.body LIKE ?", "%#{query}%", "%#{query}%")

        # Search in posts by comments
        posts_comments = @community.posts.joins(:comments).where("comments.content LIKE ?", "%#{query}%").distinct

        combined_posts = (posts_title_body + posts_comments).uniq
        @posts = combined_posts.sort_by(&:created_at).reverse.paginate(page: params[:page], per_page: per_page)
        @events = []

    when "event"
        @events = @community.events.where("title LIKE ? OR details LIKE ?", "%#{query}%", "%#{query}%").order(created_at: :desc).paginate(page: params[:page], per_page: per_page)
        @posts = []
    end

    @community_membership = Membership.where(community_id: @community.id, user_id: current_user.id).first
    @membership = @community.memberships.new

    @searched = true
    render 'show'
  end

  def edit_community_image
    @community = Community.find(params[:id])
  end



  def my_communities
    @query = params[:query]
    @category = params[:category]
    @order_by = params[:order_by]

    @communities_joined = current_user.communities.search(@query, @category, @order_by)
    @communities_administered = current_user.communities_administered.search(@query, @category, @order_by)
    @communities = (@communities_joined + @communities_administered).uniq
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_community
      @community = Community.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def community_params
      params.require(:community).permit(:title, :category_id, :description, :image, :admin_id, :background_image)
    end

end
