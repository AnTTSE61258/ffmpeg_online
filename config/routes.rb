Rails.application.routes.draw do
  resources :testings
  root 'testings#index'
  post 'execute_command' => 'execute#excute_command'
end
