Rails.application.routes.draw do
  
scope "/api",defaults: {format: 'json'} do

  get '/contribucions' =>'api/contribucions#all' # get de totes les contribucions FET
  get '/asks' =>'api/contribucions#asks' # get de tots els asks FET
  get '/news' =>'api/contribucions#news'# get de tots els news FET
  
  get '/contribucions/:id' =>'api/contribucions#show' # get d'una contribucio FET
  get '/contribucions/:id/comentaris' =>'api/contribucions#comentaris' # get dels comentaris d'una contribucio FET
  post '/contribucions' =>'api/contribucions#new' # post d'una contribucio FET
  post '/contribucions/:id' =>'api/comentaris#new' # post d'un comentari
  post '/contribucions/:id/vote' =>'api/contribucions#upvote' # post d'un vote FET
  delete '/contribucions/:id/vote' =>'api/contribucions#downvote' # delete d'un vote

  get '/users/:id' => 'api/users#show' # get info usuari
  put '/users/:id' => 'api/users#update' # update info usuari

  get '/comentaris/:id' =>'api/comentaris#show' # get comentari
  post '/comentaris/:id' =>'api/replies#new' # post d'una replica
  post '/comentaris/:id/vote' =>'api/comentaris#upvote' # post d'un vote
  delete '/comentaris/:id/vote' =>'api/comentaris#downvote' # delete d'un vote

  get '/replies/:id' => 'api/replies#show' # get d'una replica
  post '/replies/:id/vote' =>'api/replies#upvote' # post d'un vote
  delete '/replies/:id/vote' =>'api/replies#downvote' # delete d'un vote


  get '/comentaris/user/:id' =>'api/comentaris#fromuser' # get comentaris d'un usuari
  get '/contribucions/user/:id' =>'api/contribucions#fromuser' # get de totes les contribucions de l'usuari FET
  get '/comentaris/upvoted/user/:id' =>'api/comentaris#upvotedfdromuser' # get comentaris votats d'un usuari
  get '/contribucions/upvoted/user/:id' =>'api/contribucions#upvotedfdromuser' # get de totes les contribucions votades per l'usuari

end
  
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
  
    resources :contribucions do
    member do
      put 'downvote'
    end
  end
  
  resources :comentaris do
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

