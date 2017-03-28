# rubocop:disable Metrics/BlockLength

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
      # Chart list
      #
      resource :chart_lists, only: [:show]

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
      # Comments
      #
      resources :comments, only: [:create]

      #
      # Data Export Schedules
      #
      resources :data_export_schedules, only: :create

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
      # Foods
      #
      resources :foods, only: [:index, :show, :create]

      #
      # Graphs
      #
      resources :countries, only: [:index, :show]

      #
      # Harvey Bradshaw Indices
      #
      resources :harvey_bradshaw_indices, only: [:show, :create]

      #
      # Invitations
      #
      resources :invitations, only: [:show, :update]

      #
      # Passwords
      #
      resources :passwords, only: [:show, :create, :update]

      #
      # Posts
      #
      resources :posts, only: [:create, :show, :index]

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
      # Symptoms
      #
      resources :symptoms, only: [:index, :show, :create]

      #
      # Tags
      #
      resources :tags, only: [:index, :show, :create]

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

      #
      # Weathers
      #
      resources :weathers, only: [:index]
    end
  end
end
