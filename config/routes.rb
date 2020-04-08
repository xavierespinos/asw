Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  get '/contribucions/newPage', to: 'contribucions#newPage', action: :newPage , controller: 'contribucions'
  get '/contribucions/:id' =>'contribucions#show'
  get '/users/:id' =>'users#show'

  
  resources :contribucions do
    member do
      put 'upvote'
    end
  end
  
      
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'contribucions#index'
end
