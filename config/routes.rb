Rails.application.routes.draw do

  get '/shipping_quotes', to: 'shipments#index', as: 'shipping_quotes'
  post '/shipping_quotes', to: 'shipments#index'
  # get '/shipment', to: 'shipments#show', as: 'shipment'

end
