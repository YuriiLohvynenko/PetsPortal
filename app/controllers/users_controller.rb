class UsersController < ApplicationController
  before_action :authenticate_user_or_admin!

  def index
    @users = User.all
  end


  def show
    @user = User.find(params[:id])
    visit = Visit.find_by(visitor_id: current_user.id, visited_id: @user.id, created_at: Time.zone.today.all_day)
    unless visit || @user == current_user
      Visit.create(visitor_id: current_user.id, visited_id: @user.id)
    end
  end

  def my_page
    @user = current_user
    unless @user
      redirect_to login_path, alert: 'Please login first.'
      return
    end
    @visits = Visit.where(visited_id: @user.id, created_at: Time.zone.today.all_day).unread
    @notifications = current_user.notifications.unread.newest_first
    @messages = current_user.messagee.unread.order(created_at: :desc)

    @communities_joined = current_user.communities
    @communities_administered = current_user.communities_administered
    @communities = (@communities_joined + @communities_administered).uniq
    @events = current_user.joined_events
    @favorited_events = current_user.favorited_events
  end

  def additional_info
    @user = current_user
  end

  def save_additional_info
    @user = current_user

    if params[:user][:username].blank?
      flash.now[:alert] = "ニックネームは必須です。"
      render :additional_info
      return
    end

    if @user.update(user_params)
      @user.update(additional_info_completed: true)
      if @user.own_pet?
        redirect_to new_pet_path
      else
        redirect_to root_path
      end
    else
      render :additional_info
    end
  end

  private

  def user_params
    params.require(:user).permit(:own_pet, :username, :prefecture, :city, :additional_info_completed)
  end

end
