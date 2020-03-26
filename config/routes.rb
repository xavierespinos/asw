Rails.application.routes.draw do
  resources :contribucions do
    member do
      put 'upvote'
    end
    collection do
      get 'swapIndex'
    end
  end
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'contribucions#index'
end
