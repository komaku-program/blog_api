Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }, defaults: { format: :json }
  namespace :api do
    namespace :v1 do
      resources :posts, only: %i[index show create update destroy] do
        collection do
          get :archive
        end
      end
      post 'uploads', to: 'uploads#create'
    end
  end

  # ここは後で削除する？
  root 'api/v1/posts#index'
end
