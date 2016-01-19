Rails.application.routes.draw do
  root 'application#root'

  # Authentication
  devise_for :users,
             skip: [:sessions, :passwords, :registrations, :confirmations, :invitation],
             skip_helpers: false

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
      # Sessions
      #
      resources :sessions, only: [:show, :create]
      #
      # Users
      #
      resources :users, only: [:show]
    end
  end

end
