Rails.application.routes.draw do
  resources :users, only: [:create] do
    resources :books, controller: 'book_ownerships', only: [:create, :index, :update, :destroy]
  end
  resources :books, only: [:create]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
