Rails.application.routes.draw do
get 'comentaris/new'
post '/contribucions/:contribucion_id/comentaris/new', to: 'comentaris#new'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',sessions: 'users/sessions' }
  get '/contribucions/newPage', to: 'contribucions#newPage', action: :newPage , controller: 'contribucions'
  get '/contribucions/askPage', to: 'contribucions#askPage', action: :askPage , controller: 'contribucions'
  get '/contribucions/submitted', to: 'contribucions#submitted', action: :submitted , controller: 'contribucions'
  get '/comentaris/threads', to: 'comentaris#threads', action: :threads , controller: 'comentaris'
  get '/users/:id' =>'users#show'
  get '/users/:id/edit', :to => 'users#edit', :as => :user
  
  resources :contribucions do
     post 'comment', on: :member
     resources :comentaris
   end
  
  resources :contribucions do
    member do
      put 'upvote'
    end
  end
  resources :comentaris do
    resources :comentaris
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'contribucions#index'
end

