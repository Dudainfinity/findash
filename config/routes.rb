Rails.application.routes.draw do
  resources :transactions, only: %i[create destroy]

  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#index"
end
