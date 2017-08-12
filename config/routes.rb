Rails.application.routes.draw do
  root 'home#index'
  post 'execute_command' => 'execute#excute_command'
  resources :requests, only: [:create, :destroy]
end
