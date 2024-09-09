class AdminsController < ApplicationController
    before_action :authenticate_admin!
    def posts
        @posts = Post.all
    end

    def events
        @events = Event.all
    end

    def users
        @users = User.all
    end

    def diaries
        @diaries = Diary.all
    end

    def communities
        @communities = Community.all
    end

    def pets
        @pets = Pet.all
    end

    def categories
        @categories = Category.all
    end

    def prohibited_words
        @prohibited_words = ProhibitedWord.all
        @prohibited_word = ProhibitedWord.new
    end

    def messages
        @admin_messages = AdminMessage.all
    end
    
end