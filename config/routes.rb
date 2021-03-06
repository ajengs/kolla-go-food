Rails.application.routes.draw do
  get 'admin/index', as: 'admin'

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :buyers
  resources :categories
  resources :carts
  resources :foods do
    resources :reviews
  end
  resources :line_items
  resources :orders
  resources :restaurants do
    resources :reviews
  end
  resources :reviews
  resources :tags
  resources :users do
    member do
      get 'topup'
      patch 'topup' => :save_topup
    end
  end

  resources :vouchers

  root 'store#index', as: 'store_index'
  get 'home/hello'
  get 'home/goodbye'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :foods
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
