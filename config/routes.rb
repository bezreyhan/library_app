Rails.application.routes.draw do
  resources :users, only: [:create] do
    post 'books', to: 'book_ownerships#create', as: 'book_ownerships'
    put 'books/:book_id', to: 'book_ownerships#update', as: 'book_ownership'
  end
  resources :books, only: [:create]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
