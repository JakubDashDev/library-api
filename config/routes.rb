Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :books, only: %i[index show create destroy] do
    member do
      post :borrow
      post :return
    end
  end

  resources :customers, only: %i[index show create]
end
