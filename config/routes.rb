Rails.application.routes.draw do

  root "top#index"
  resources :top, only: [:index, :create, :destroy]
  get "top/index/:id" => 'top#index'
  resources :groups, only: [:new, :create, :destroy]
  resources :owners, only: :index
  post "owners/search" => 'owners#search'

  devise_for :users

end
