Cuewer::Application.routes.draw do
  get "welcome/index"
  resources :users
  
  post '/users/:username', to: 'users#login'
  post '/users/send_code/:username', to: 'users#send_code'
  post '/users/validate_code/:code', to: 'users#validate_code'

  root 'welcome#index'
end
