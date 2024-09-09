class SubcategoriesController < ApplicationController
  skip_before_action :check_pet_info, only: [:index]
    def create
      @category = Category.find(params[:category_id])
      @subcategory = @category.subcategories.build(subcategory_params)

      if @subcategory.save
        redirect_to @category
      else
        render 'categories/show'
      end
    end

    def index
        category = Category.find(params[:category_id])
        subcategories = category.subcategories

        render json: subcategories
    end

    private

    def subcategory_params
      params.require(:subcategory).permit(:name)
    end
end
