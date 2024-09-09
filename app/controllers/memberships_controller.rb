class MembershipsController < ApplicationController
    before_action :set_community

    def create
      @membership = @community.memberships.new
      @membership.user = current_user
      if @membership.save
        redirect_to community_path(@community)
      else
        redirect_to community_path(@community)
      end
    end

    def edit
      @membership = @community.memberships.find(params[:id])
    end

    def update
      @membership = @community.memberships.find(params[:id])
      if @membership.update(membership_params)
        redirect_to community_path(@community)
      else
        redirect_to community_path(@community)
      end
    end

    def destroy
      @membership = @community.memberships.find(params[:id])
      @membership.destroy
      redirect_to community_path(@community)
    end

    private

    def set_community
      @community = Community.find(params[:community_id])
    end
  end
