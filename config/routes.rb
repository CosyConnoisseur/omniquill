Rails.application.routes.draw do
  get "stickies/new"
  get "stickies/create"
  get "characters/show"
  get "characters/new"
  get "characters/create"
  get "characters/edit"
  get "characters/update"
  get "characters/destroy"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "campaigns#index"
  
  # Defines the campaign routes
  get "campaigns/new", to: "campaigns#new", as: :new_campaign
  get "campaigns/:id/join", to: "campaigns#join", as: :join_campaign
  post "campaigns/:id/join", to: "campaigns#add_player", as: :add_player
  # Will likely need to change the routes for chapters, since campaign show page will likely have all the chapters in it.
  resources :campaigns, only: [ :create ] do
    resources :chapters, except: [ :destroy ] do
      resources :stickies, only: [ :new, :create ]
    end
  end

  # Defines the character routes
  resources :characters do
    collection do
      post :parse_sheet
    end
  end
end
