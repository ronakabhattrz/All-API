Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users
      devise_scope :user do
        # post "/sign_in", :to => 'sessions#create'
        # post "/sign_up", :to => 'registrations#create'
        # delete "/sign_out", :to => 'sessions#destroy'
        post 'sign_up' => 'registrations#create'                                    
        post 'sign_in' => 'sessions#create'                                           
        delete 'sign_out' => 'sessions#destroy'  
      end
    end
  end
end
