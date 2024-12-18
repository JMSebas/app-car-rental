Rails.application.routes.draw do
  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }

  namespace :api do 
    namespace :v1 do 
      resources :users
      resources :invoices do
        collection do 
          get :invoices_user
        end 

      end
      resources :payment_types
      resources :reparations
      resources :rates
      resources :rentals do
        collection do 
          get :rentals_user
          patch :set_completed
        end 

      end 
      resources :seasons
      resources :reservations do
        collection do 
        patch :set_cancelled
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
