class EventsController < ApplicationController
  include CommunitiesHelper
  before_action :authenticate_user_or_admin!

    def new
      @community = Community.find(params[:community_id])
      if community_member(@community) || current_user == @community.admin
        @event = @community.events.build
      else
        redirect_to community_path(@community)
      end
    end

    def create
      @community = Community.find(params[:community_id])
      @event = @community.events.build(event_params)
      @event.user = current_user
      if @event.save
        EventNotification.with(event: @event).deliver(@community.members.reject { |recipient| recipient == current_user })
        if current_user != @community.admin
          EventNotification.with(event: @event).deliver(@community.admin)
        end
        redirect_to community_event_path(@community, @event)
      else
        render 'new'
      end
    end

    def index
      @community = Community.find(params[:community_id]) # This line was missing

      @query = params[:query]
      @start_date = params[:start_date]
      @end_date = params[:end_date]
      @place = params[:place]
      @order_by = params[:order_by]

      @events = @community.events.search(@query, @start_date, @end_date, @place, @order_by)
    end

    def show
      @community = Community.find(params[:community_id])
      @event = @community.events.find(params[:id])
      @comments = @event.comments.order(:created_at).paginate(page: params[:page], per_page: 10)
      @comment = @community.posts.new
      @user = User.with_deleted.find_by(id: @event.user_id)
    end

    def edit
      @community = Community.find(params[:community_id])
      @event = @community.events.find(params[:id])
    end

    def update
      @community = Community.find(params[:community_id])
      @event = @community.events.find(params[:id])
      if @event.update(event_params)
        flash[:success] = "Event updated!"
        redirect_to community_event_path(@community, @event)
      else
        render 'edit'
      end
    end

    def destroy
      @community = Community.find(params[:community_id])
      @event = @community.events.find(params[:id])
      @event.destroy
      redirect_to community_path(@community)
    end

    def all_events
      @query = params[:query]
      @start_date = params[:start_date]
      @end_date = params[:end_date]
      @place = params[:place]
      @order_by = params[:order_by]
      events = Event.all.search(@query, @start_date, @end_date, @place, @order_by)
      @events = Kaminari.paginate_array(events).page(params[:page]).per(20)
    end

    def my_events
      @query = params[:query]
      @start_date = params[:start_date]
      @end_date = params[:end_date]
      @place = params[:place]
      @order_by = params[:order_by]
      events = current_user.joined_events.search(@query, @start_date, @end_date, @place, @order_by).to_a
      @events = Kaminari.paginate_array(events).page(params[:page]).per(20)
    end

    def edit_event_image
      @event = Event.find(params[:id])
    end

    private

    def event_params
        params.require(:event).permit(:title, :event_date, :event_place, :people_limit, :details, :image, :background_image)
    end
  end
