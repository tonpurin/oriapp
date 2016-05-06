Rails.application.routes.draw do

  root "top#index"
  resources :top, only: [:index, :create, :destroy]
  get "top/index/:id" => 'top#index'
  resources :groups, only: [:new, :create, :destroy]
  # get "/groups/show/:id" => 'top#show_group_member'
  devise_for :users

end
