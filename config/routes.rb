Cuewer::Application.routes.draw do
  get "welcome/index"
  resources :users
  post '/users/:username', to: 'users#login'

  root 'welcome#index'
end
