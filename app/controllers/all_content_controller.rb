class AllContentController < ApplicationController
  def index
    query = params[:query]
    category = params[:category]
    order_by = params[:order_by]
    start_date = params[:start_date]
    end_date = params[:end_date]
    place = params[:place]

    # Get all communities, posts and events based on search query
    communities = Community.search(query, category, order_by)
    posts = Post.search(query)
    events = Event.search(query, start_date, end_date, place, order_by)

    # Gather all the content together
    @all_content = communities + posts + events

    # Now get all posts and events for each community
    communities.each do |community|
      @all_content += community.posts if community.posts.present?
      @all_content += community.events if community.events.present?
    end

    # Sort by updated_at
    @all_content.sort_by!(&:updated_at).reverse!

    # You can add more filters and sorts here based on params, if needed
  end
end
