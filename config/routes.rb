Wandermust::Application.routes.draw do
  match "signup" => 'users#new', :as => "signup"
  match "login" => 'sessions#new', :as => "login"
  match "logout" => 'sessions#destroy', :as => "logout"

  get "destinations/:id/save/" => 'destinations#save', :as => 'save_destination'

  resources :users
  resources :sessions, :except => [:edit, :update, :index]
  resources :destinations, :except => [:edit, :update, :delete]

  root :to => 'destinations#index'

end
