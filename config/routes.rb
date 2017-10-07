Rails.application.routes.draw do
  root 'home#index'
  post 'execute_command' => 'execute#excute_command'
  resources :requests, only: [:create, :destroy]
  post 'set_request_option' => 'requests#set_option'
  post 'process_request' => 'requests#process_request'
  post 'clear_log' => 'requests#clear_log'
  post 'get_request_thumbnail' => 'requests#get_input_thumbnail'
end
