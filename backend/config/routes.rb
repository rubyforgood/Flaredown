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
      resources :comments, only: [:create, :show, :index]

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
      # Promotion Rates
      #
      resources :promotion_rates, only: [:show, :create, :update]

      #
      # Invitations
      #
      resources :invitations, only: [:show, :update]

      #
      # Notifications
      #
      resources :notifications, only: [:index] do
        collection do
          delete ':notificateable_type/:notificateable_id', action: :destroy
          put ':notificateable_type/:notificateable_id', action: :update
        end
      end

      #
      # Oracle requests
      #
      resources :oracle_requests, only: [:show, :create, :update]

      #
      # Passwords
      #
      resources :passwords, only: [:show, :create, :update]

      #
      # Postables
      #
      resources :postables, only: [:index]

      #
      # Posts
      #
      resources :posts, only: [:create, :show, :index]

      #
      # Profiles
      #
      resources :profiles, only: [:index, :show, :update]

      #
      # Activations
      #
      # resources :activations, only: [:edit]

      get '/unsubscribe/:notify_token', to: 'unsubscribes#update', as: :unsubscribe

      # Pusher
      #
      resource :pusher, only: [:create]

      #
      # Reactions
      #
      resources :reactions, only: [:create, :update, :destroy]

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
      #
      #
      resources :topic_followings, only: [:show, :update]

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
      resources :users, only: [:index, :show]

      #
      # Weathers
      #
      resources :weathers, only: [:index]

      resources :patterns
      resources :charts_pattern, only: [:index]
    end
  end
end
