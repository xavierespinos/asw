Rails.application.routes.draw do

  scope "/",defaults: {format: 'json'} do

    get '/api/contribucions' =>'api/contribucions#news' # get de totes les contribucions FET
    get '/api/contribucions/asks' =>'api/contribucions#asks' # get de tots els asks FET
    get '/api/contribucions/urls' =>'api/contribucions#urls'# get de tots els news FET
    delete '/api/contribucions/:id' =>'api/contribucions#destroy' # delete contribucion FET

    get '/api/contribucions/:id' =>'api/contribucions#show' # get d'una contribucio FET
    get '/api/contribucions/:id/comentaris' =>'api/contribucions#comentaris' # get dels comentaris d'una contribucio FET
    post '/api/contribucions' =>'api/contribucions#new' # post d'una contribucio FET
    post '/api/contribucions/:id' =>'api/comentaris#new' # post d'un comentari FET
    put '/api/contribucions/:id/vote' =>'api/contribucions#upvote' # put d'un vote FET
    put '/api/contribucions/:id/downvote' =>'api/contribucions#downvote' # put d'un downvote FET

    get '/api/users/:id' => 'api/users#show' # get info usuari FET
    put '/api/users' => 'api/users#update' # update info usuari FET

    get '/api/comentaris/:id' =>'api/comentaris#show' # get comentari FET
    get '/api/comentaris/user/:id' =>'api/comentaris#fromuser' # get comentaris d'un usuari FET
    
    get '/api/comentaris/:id/replies' =>'api/comentaris#showReplies' # get de les repliques d'un comentari FET
    post '/api/comentaris/:id' =>'api/comentaris#replies' # post d'una replica FET
    put '/api/comentaris/:id/vote' =>'api/comentaris#upvote' # put d'un vote  FET
    put '/api/contribucions/:id/downvote' =>'api/comentaris#downvote' # put d'un downvote FET

    get '/api/contribucions/user/:id' =>'api/contribucions#fromUser' # get de totes les contribucions de l'usuari FET
    get '/api/comentaris/upvoted/user/:id' =>'api/comentaris#upvotedfdromuser' # get comentaris votats d'un usuari
    get '/api/contribucions/upvoted/user/:id' =>'api/contribucions#upvotedfdromuser' # get de totes les contribucions votades per l'usuari

  end
  
get 'comentaris/new'
post '/contribucions/:contribucion_id/comentaris/new', to: 'comentaris#new'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',sessions: 'users/sessions' }
  get '/contribucions/newPage', to: 'contribucions#newPage', action: :newPage , controller: 'contribucions'
  get '/contribucions/askPage', to: 'contribucions#askPage', action: :askPage , controller: 'contribucions'
  get '/contribucions/submitted', to: 'contribucions#submitted', action: :submitted , controller: 'contribucions'
  get '/contribucions/liked', to: 'contribucions#liked', action: :liked , controller: 'contribucions'
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

