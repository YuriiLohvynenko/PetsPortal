# app/controllers/prohibited_words_controller.rb
class ProhibitedWordsController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_prohibited_word, only: [:edit, :update, :destroy]

    def index
      @prohibited_words = ProhibitedWord.all
      @prohibited_word = ProhibitedWord.new
    end

    def create
      @prohibited_word = ProhibitedWord.new(prohibited_word_params)

      respond_to do |format|
        if @prohibited_word.save
          format.html { redirect_to admin_prohibited_words_path }
          format.js   # This renders create.js.erb
        else
          format.html { render :index }
          format.js   # This renders create.js.erb
        end
      end
    end

    def edit
      @prohibited_word = ProhibitedWord.find(params[:id])
      render template: "admins/prohibited_words/edit"
    end

    def update
      @prohibited_word = ProhibitedWord.find(params[:id])
      if @prohibited_word.update(prohibited_word_params)
        redirect_to admin_prohibited_words_path
      else
        render :edit
      end
    end

    def destroy
      @prohibited_word = ProhibitedWord.find(params[:id])
      @prohibited_word.destroy

      respond_to do |format|
        format.html { redirect_to admin_prohibited_words_path }
      end
    end

    private

    def prohibited_word_params
      params.require(:prohibited_word).permit(:word)
    end

    def set_prohibited_word
      @prohibited_word = ProhibitedWord.find(params[:id])
    end
end
