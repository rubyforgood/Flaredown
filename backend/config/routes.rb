Rails.application.routes.draw do
  root 'application#root'

  # Authentication
  devise_for :users,
             skip: [:sessions, :passwords, :registrations, :confirmations],
             skip_helpers: false

  #
  # API
  #
  namespace :api, defaults: { format: 'json' } do
    scope module: :v1 do
      resources :sessions, only: :show
    end
  end

end
