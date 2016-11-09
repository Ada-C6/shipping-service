Rails.application.routes.draw do

  get '/shipping_quotes', to: 'shipments#index', as: 'shipping_quotes'
  get '/shipment', to: 'shipments#show', as: 'shipment'

end
