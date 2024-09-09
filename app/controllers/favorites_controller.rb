class FavoritesController < ApplicationController

    def create
      @favorable = find_favorable
      @favorite = @favorable.favorites.build(user: current_user)
  
      if @favorite.save
        redirect_back(fallback_location: root_path)
      else
        redirect_back(fallback_location: root_path)
      end
    end
  
    def destroy
      @favorable = find_favorable
      @favorite = @favorable.favorites.find_by(user: current_user)
      if @favorite.destroy
        redirect_back(fallback_location: root_path)
      else
        redirect_back(fallback_location: root_path)
      end
    end
  
    private
  
    def find_favorable
      if params[:event_id]
        @favorable = Event.find_by_id(params[:event_id])
      end
    end
  end
  