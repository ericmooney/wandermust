Wandermust::Application.routes.draw do
  # match "signup" => 'users#new', :as => "signup"
  # match "login" => 'sessions#new', :as => "login"
  # match "logout" => 'sessions#destroy', :as => "logout"

  resources :destinations, :except => [:edit, :update, :destroy]

  root :to => 'destinations#index'


end
