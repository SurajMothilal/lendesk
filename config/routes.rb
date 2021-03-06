Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post 'sign_up', to: 'registration#register'
      post 'sign_in', to: 'authentication#authenticate'
      root to: 'home#index'
    end
  end
end
