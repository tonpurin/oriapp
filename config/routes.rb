Rails.application.routes.draw do

  root "top#index"
  resources :top, only: [:index, :create, :destroy]
  get "top/index/:id" => 'top#index'
  devise_for :users

end
