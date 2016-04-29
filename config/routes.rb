Rails.application.routes.draw do

  root "top#index"
  resources :top, only: [:index, :create, :destroy]
  devise_for :users

end
