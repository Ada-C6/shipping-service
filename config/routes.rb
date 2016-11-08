Rails.application.routes.draw do

  get '/shipments', to: 'shipments#index', as: 'shipments'
  get '/shipments', to: 'shipments#search', as: 'shipments_search'

end
