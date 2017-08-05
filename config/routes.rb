Rails.application.routes.draw do
  resources :testings
  root 'testings#index'

end
