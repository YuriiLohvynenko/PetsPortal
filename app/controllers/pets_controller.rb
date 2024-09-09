class PetsController < ApplicationController
  before_action :set_pet, only: %i[ show edit update destroy pet_owner ]
  before_action :pet_owner, only: %i[ edit update destroy ]
  before_action :authenticate_user_or_admin!
  skip_before_action :check_pet_info, only: [:new, :create]

  # GET /pets or /pets.json
  def index
    @category = params[:category]
    @subcategory = params[:subcategory]
    @prefecture = params[:prefecture]
    @city = params[:city]
    @free_words = params[:search]
    @pets = Pet.joins(:user).search(@category, @subcategory, @prefecture, @city, @free_words)
  end

  # GET /pets/1 or /pets/1.json
  def show
  end

  # GET /pets/new
  def new
    @pet = Pet.new
  end

  # GET /pets/1/edit
  def edit
  end

  # POST /pets or /pets.json
  def create
    @pet = Pet.new(pet_params)
    @pet.user = current_user

    respond_to do |format|
      if @pet.save
        current_user.update(own_pet: true)
        format.html { redirect_to my_page_path}
        format.json { render :show, status: :created, location: @pet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pets/1 or /pets/1.json
  def update
    respond_to do |format|
      if @pet.update(pet_params)
        format.html { redirect_to pet_url(@pet) }
        format.json { render :show, status: :ok, location: @pet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pets/1 or /pets/1.json
  def destroy
    @pet.destroy

    respond_to do |format|
      format.html { redirect_to pets_url}
      format.json { head :no_content }
    end
  end

  def my_pets
    @pets = Pet.where(user_id: current_user.id).order(created_at: :asc)
  end

  def pet_owner
    unless current_user && current_user.id == @pet.user_id
      redirect_to pets_path
    end
  end

  def set_profile_display
    current_user.pets.update_all(profile_display: false)
    @pet = Pet.find(params[:id])
    @pet.update(profile_display: true)
    redirect_to my_pets_path
  end

  private
    def set_pet
      @pet = Pet.find(params[:id])
    end

    def pet_params
      params.require(:pet).permit(:name, :age, :gender, :location, :user_id, :image, :category_id, :subcategory_id)
    end
end
