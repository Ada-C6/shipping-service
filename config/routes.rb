Rails.application.routes.draw do
 resources :shipping_services, only: [:index, :show]
end
