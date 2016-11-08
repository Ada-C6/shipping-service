Rails.application.routes.draw do

  get '/shipments', to: 'shipments#index', as: 'shipments'
  post '/shipments', to: 'shipments#create', as: 'shipments_create'

end
