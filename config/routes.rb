Rails.application.routes.draw do
  resources :documents
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get 'add-document', to: 'documents#new', as: 'add_document'
end
