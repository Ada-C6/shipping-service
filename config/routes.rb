Rails.application.routes.draw do
 resources :quotes, only: [:create]
end
