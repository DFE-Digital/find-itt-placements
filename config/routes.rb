Rails.application.routes.draw do
  mount MissionControl::Jobs::Engine, at: "/jobs"

  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  scope via: :all do
    get "/404", to: "errors#not_found"
    get "/422", to: "errors#unprocessable_entity"
    get "/429", to: "errors#too_many_requests"
  end
  match "/500", to: "errors#internal_server_error", via: :all, as: :internal_server_error
  get "/sign-in", to: "sessions#new", as: :sign_in

  if ENV.fetch("SIGN_IN_METHOD", "persona") == "persona"
    get "/personas", to: "personas#index"
    get "/auth/developer/sign-out", to: "sessions#destroy", as: :sign_out
    post "/auth/developer/callback", to: "sessions#callback", as: :auth_callback
  else
    get "/auth/dfe/callback" => "sessions#callback"
    get "/auth/dfe/sign-out" => "sessions#destroy", as: :sign_out
    get "/auth/failure", to: "sessions#failure"
  end

  resources :organisations, only: %i[show index]
  resources :placement_preferences, only: %i[index show] do
    collection do
      get "new", to: "placement_preferences/add_hosting_interest#new", as: :new_add_hosting_interest
      get "new/:state_key/:step", to: "placement_preferences/add_hosting_interest#edit", as: :add_hosting_interest
      put "new/:state_key/:step", to: "placement_preferences/add_hosting_interest#update"
    end
  end
  resources :change_organisation, only: %i[index] do
    get "/update_organisation", to: "change_organisation#update_organisation", as: :update_organisation
  end
  resources :admin_dashboard, only: %i[index]
end
