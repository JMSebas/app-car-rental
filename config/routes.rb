Rails.application.routes.draw do
  
  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  namespace :api do 
    namespace :v1 do 
      resources :users
      resources :invoices
      resources :payment_types
      resources :reparations
      resources :rates
      resources :rentals
      resources :seasons
      resources :reservations do
        collection do 
        patch :set_completed
        get :reservations_user
        end
      end
      
      resources :vehicles do
        get :vehicles_available, on: :collection
      end
    end
  end

  # get '/api-docs' => 'swagger_ui#index' # Esta línea sirve la documentación de Swagger

  # get "up" => "rails/health#show", as: :rails_health_check
end
