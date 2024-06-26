Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server', via: :all
  match '/422', to: 'errors#unprocessable', via: :all

  # Defines the root path route ("/")
  root "photo_gallery#index"
  resources :photo_gallery, path: 'gallery' do
    post :set_thumbnail, action: :set_thumbnail, controller: 'photo_gallery'
    resources :photo, except: [:new, :index]
  end
  get :my_galleries, action: :my_galleries, controller: 'photo_gallery'
end
