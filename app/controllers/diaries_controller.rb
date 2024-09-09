class DiariesController < ApplicationController
  before_action :set_user, only: [:new, :create, :edit, :update, :destroy, :show]
  before_action :set_diary, only: %i[ show edit update destroy diary_owner ]
  before_action :diary_owner, only: %i[ edit update destroy ]
  before_action :authenticate_user_or_admin!, except: [:index, :show] # 一覧表示と詳細表示は認証を求めない

  def index
    @user = User.find(params[:user_id])
    if current_user.friends.include?(@user)
      if params[:day]
        date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
        start_of_day = date.in_time_zone("Tokyo").beginning_of_day
        end_of_day = date.in_time_zone("Tokyo").end_of_day
        @diaries = @user.diaries.where(created_at: start_of_day..end_of_day)
      elsif params[:month] && params[:year]
        start_date = Date.new(params[:year].to_i, params[:month].to_i, 1).in_time_zone("Tokyo").beginning_of_month
        end_date = start_date.end_of_month
        @diaries = @user.diaries.where(created_at: start_date..end_date)
      else
        @diaries = @user.diaries.all
      end
    else
      redirect_to root_path
    end
  end

  def my_diaries
    if params[:month] && params[:year]
      start_time = Time.zone.local(params[:year].to_i, params[:month].to_i).beginning_of_month
      end_time = Time.zone.local(params[:year].to_i, params[:month].to_i).end_of_month

      if params[:day]
        start_time = Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i).beginning_of_day
        end_time = Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i).end_of_day
      end

      @diaries = current_user.diaries.where(created_at: start_time..end_time)
    else
      @diaries = current_user.diaries.all
    end
  end


  def show
    if current_user != @user && !current_user.friends.include?(@user)
      redirect_to root_path
    end
  end

  def new
    @diary = @user.diaries.new
  end

  def edit
  end

  def create
    @diary = @user.diaries.new(diary_params)
    @diary.user = @user

    respond_to do |format|
      if @diary.save
        format.html { redirect_to user_diary_path(@user, @diary) }
        format.json { render :show, status: :created, location: @diary }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @diary.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @diary.update(diary_params)
        format.html { redirect_to user_diary_path(@user, @diary) }
        format.json { render :show, status: :ok, location: @diary }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @diary.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @diary.destroy

    respond_to do |format|
      format.html { redirect_to user_diaries_path(@user) }
      format.json { head :no_content }
    end
  end

  private
  def set_user
    @user = params[:user_id] ? User.find(params[:user_id]) : current_user
  end


  def set_diary
    @diary = @user.diaries.find(params[:id])
  end

  def diary_owner
    unless @diary.user_id == @user.id
      redirect_to user_diaries_path(@user)
    end
  end

  def diary_params
    params.require(:diary).permit(:title, :content, :image)
  end
end
