Rails.application.routes.draw do
  get '/contribucions/newPage', to: 'contribucions#newPage', action: :newPage , controller: 'contribucions'
  resources :contribucions do
    member do
      put 'upvote'
    end
  end
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'contribucions#index'
end
