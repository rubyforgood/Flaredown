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
  namespace :api, defaults: { format: 'json' } do
    scope module: :v1 do
      #
      # Countries
      #
      resources :countries, only: [:index, :show]

      #
      # Invitations
      #
      resources :invitations, only: [:show, :update]

      #
      # Profiles
      #
      resources :profiles, only: [:show, :update]

      #
      # Profiles
      #
      resource :pusher, only: [:create]

      #
      # Sessions
      #
      resources :sessions, only: [:show, :create]

      #
      # Sexes
      #
      resources :sexes, only: [:index, :show]

      #
      # Steps
      #
      resources :steps, only: [:index, :show]

      #
      # Users
      #
      resources :users, only: [:show]
    end
  end

end
