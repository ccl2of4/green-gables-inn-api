Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :suites
  resources :clients
  resources :reservations
  resources :accepted_reservations
  resources :unaccepted_reservations
end
