Rails.application.routes.draw do


  resources :tweets
  resources :perfis
  root to: 'application#index'

  #páginas de erro
  match '/404', to: 'application#not_found', via: :all
  match '/500', to: 'application#internal_server_error', via: :all

  #users routes
  devise_for :users, :skip => [:registrations]
	as :user do
	  get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
	  patch 'users' => 'devise/registrations#update', :as => 'user_registration'
	end
  resources :users, except: [:show], path: "/controle_de_usuarios"


end
