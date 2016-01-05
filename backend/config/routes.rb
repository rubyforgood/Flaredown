Rails.application.routes.draw do

  #
  # API
  #
  namespace :api, defaults: { format: 'json' } do
    scope module: :v1 do
      resources :sessions, only: :show
    end
  end

end
