Rails.application.routes.draw do
  root 'application#root'

  # Authentication
  devise_for :users,
             skip: [:sessions, :passwords, :registrations, :confirmations, :invitation],
             skip_helpers: false,
             controllers: {
               omniauth_callbacks: 'api/v1/omniauth_callbacks'
             }

  #
  # API
  #
  get "/api/minimum-client", to: "application#root"

  namespace :api, defaults: { format: 'json' } do
    scope module: :v1 do
      #
      # Charts
      #
      resource :charts, only: [:show]

      #
      # Checkins
      #
      resources :checkins, only: [:index, :show, :create, :update]

      #
      # Conditions
      #
      resources :conditions, only: [:index, :show, :create]

      #
      # Day Habits
      #
      resources :day_habits, only: [:index, :show]

      #
      # Discourse SSO
      #
      resource :discourse, only: [:create]

      #
      # Education Levels
      #
      resources :education_levels, only: [:index, :show]

      #
      # Ethnicities
      #
      resources :ethnicities, only: [:index, :show]

      #
      # Graphs
      #
      resources :countries, only: [:index, :show]

      #
      # Invitations
      #
      resources :invitations, only: [:show, :update]

      #
      # Passwords
      #
      resources :passwords, only: [:show, :create, :update]

      #
      # Profiles
      #
      resources :profiles, only: [:show, :update]

      #
      # Pusher
      #
      resource :pusher, only: [:create]

      #
      # Registrations
      #
      resources :registrations, only: [:create]

      #
      # Searches
      #
      resource :searches, only: [:show]

      #
      # Sessions
      #
      resources :sessions, only: [:create]

      #
      # Sexes
      #
      resources :sexes, only: [:index, :show]

      #
      # Steps
      #
      resources :steps, only: [:index, :show]

      #
      # Symptoms
      #
      resources :symptoms, only: [:index, :show, :create]

      #
      # Tags
      #
      resources :tags, only: [:index, :show, :create]

      #
      # Foods
      #
      resources :foods, only: [:index, :show, :create]

      #
      # Trackings
      #
      resources :trackings, only: [:index, :show, :create, :destroy]

      #
      # Treatments
      #
      resources :treatments, only: [:index, :show, :create]

      #
      # Users
      #
      resources :users, only: [:show]
    end
  end
end
