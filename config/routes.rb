Rails.application.routes.draw do
  resources :users
  root to: 'users#index', get: '/users'
  post 'users/search'
end
