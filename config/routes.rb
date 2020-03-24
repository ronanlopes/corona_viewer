Rails.application.routes.draw do


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
  resources :tweets

  get "/get_popular_tweets" => "application#get_popular_tweets"


  get "/heat_map" => "features#heat_map"
  get "/word_cloud" => "features#word_cloud"
  get "/get_cloud_path" => "features#get_cloud_path"
  get "/users_operational_system" => "features#users_operational_system"



end
