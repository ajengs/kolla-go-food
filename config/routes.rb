Rails.application.routes.draw do
  resources :categories
  resources :carts
  resources :line_items
  resources :buyers
  resources :foods
  root 'store#index', as: 'store_index'
  get 'home/hello'
  get 'home/goodbye'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
