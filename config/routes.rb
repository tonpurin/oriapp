Rails.application.routes.draw do

  root "top#index"
  resources :top, only: [:index, :create, :destroy]
  get "top/index/:id" => 'top#index'
  resources :groups, only: [:new, :create, :destroy, :show]
  get "groups/consent/:id" => 'groups#consent'
  get "groups/object/:id" => 'groups#object'
  resources :owners, only: [:index, :create, :destroy]
  post "owners/search" => 'owners#search'

  devise_for :users

end
