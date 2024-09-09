Rails.application.routes.draw do
  devise_for :admins, :skip => [:registrations]
  as :admin do
    get 'admins/edit' => 'devise/registrations#edit', :as => 'edit_admin_registration'
    put 'admins' => 'devise/registrations#update', :as => 'admin_registration'
  end

  devise_for :users, :skip => [:registrations], controllers: { confirmations: 'confirmations' }
  as :user do
    get 'users/sign_up' => 'devise/registrations#new', :as => 'new_user_registration'
    post 'users' => 'devise/registrations#create', :as => 'user_registration'
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration_update'
    delete 'users' => 'devise/registrations#destroy', :as => 'user_registration_destroy'
  end

  resources :categories do
    resources :subcategories
  end

  resources :questions do
    resources :answers, only: [:create, :update, :destroy] do
      post 'like', to: 'likes#create'
      delete 'unlike', to: 'likes#destroy'
      post 'pick', to: 'answers#pick'
    end
  end
  resources :communities do
    get 'search', on: :member
    resources :memberships
    resources :posts do
      resources :comments, only: [:create, :destroy], defaults: { commentable: 'post' }
      post 'like', to: 'likes#create'
      delete 'unlike', to: 'likes#destroy'
    end
    resources :events do
      resources :comments, only: [:create, :destroy], defaults: { commentable: 'post' }
      post 'like', to: 'likes#create'
      delete 'unlike', to: 'likes#destroy'
      post 'favorite', to: 'favorites#create'
      delete 'unfavorite', to: 'favorites#destroy'
    end
  end

  resources :users, only: [] do
    resources :diaries do
      collection do
        get :my_diaries
      end
      post 'like', to: 'likes#create'
      delete 'unlike', to: 'likes#destroy'
      resources :comments, only: [:create, :destroy], defaults: { commentable: 'diary' }
    end
  end


  resources :pets do
    member do
      post :set_profile_display
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  authenticated :admin do
    root to: 'admins#pets', as: :admin_root
  end
  root "users#my_page"
  get "my_diaries", to: "diaries#my_diaries"
  get "my_pets", to: "pets#my_pets"
  get "my_communities", to: "communities#my_communities"
  get "my_questions", to: "questions#my_questions"
  resources :users, only: [:show] do
    member do
      get :confirm_email
    end
  end
  resources :friend_requests, only: [:create] do
    member do
      put :accept
      delete :reject
    end
  end
  resources :friendships, only: [:create, :destroy]
  resources :messages, only: [:create, :show, :index] do
    member do
      patch :mark_as_read
    end
  end

  resources :comments, path: "community/:community_id/comments/", only: [:show]

  resources :comments, only: [:create, :destroy], defaults: { commentable: 'post' } do
    resources :comments, only: [:create, :destroy, :show], defaults: { commentable: 'comment' } do
      post 'like', to: 'likes#create'
      delete 'unlike', to: 'likes#destroy'
    end
  end

  resources :visits, only: [:index] do
    get 'read', to: 'visits#read'
  end
  resources :prohibited_words, except: [:show]
  resources :admin_messages

  get 'friendrequest_sent/:id', to: 'friend_requests#sent', as: 'friendrequest_sent'

  get "notifications", to: "notifications#index"
  get "my_page", to: "users#my_page"
  get 'all_content', to: 'all_content#index'
  get "/admin/posts", to: "admins#posts"
  get "/admin/communities", to: "admins#communities"
  get "/admin/events", to: "admins#events"
  get "/admin/users", to: "admins#users"
  get "/admin/diaries", to: "admins#diaries"
  get "/admin/pets", to: "admins#pets"
  get "/admin/categories", to: "admins#categories"
  get "/admin/prohibited_words", to: "admins#prohibited_words"
  get "/admin/messages", to: "admins#messages", as: "admin_notifications"

  get "/my_events", to: "events#my_events"
  get "/all_events", to: "events#all_events"
  get "/all_posts", to: "posts#all_posts"
  get "/my_posts", to: "posts#my_posts"
  get "/confirmation_page", to: "home#confirmation", as: "confirmation_page"
  get "/notification/:id", to: "notifications#mark_as_read", as: "notification"

  get '/additional_info', to: 'users#additional_info'
  post '/save_additional_info', to: 'users#save_additional_info'

  get '/edit_community_image/:id', to: 'communities#edit_community_image', as: 'edit_community_image'
  get '/edit_post_image/:id', to: 'posts#edit_post_image', as: 'edit_post_image'
  get '/edit_event_image/:id', to: 'events#edit_event_image', as: 'edit_event_image'

end
