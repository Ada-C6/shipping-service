Rails.application.routes.draw do

 get 'shipping_services', to: 'shipping_services#search', as: 'search_options'

 get 'shipping_services/:id', to: 'shipping_services#show', as: 'shipping_option'
end
