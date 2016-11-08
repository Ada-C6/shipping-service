Rails.application.routes.draw do
  get 'quotes/index'

  get 'quotes/show'

  get 'pets/search', to: 'pets#search', as: 'pets_search'

  get 'quotes/create/', to: 'quotes#create', as: 'quotes_create'

  get 'quotes/edit'

  get 'quotes/update'

  get 'quotes/destroy'
end
