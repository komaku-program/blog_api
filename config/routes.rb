Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }, defaults: { format: :json }

  devise_scope :user do
    get 'users/check_login', to: 'users/sessions#check_login', defaults: { format: :json }
  end

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

  # ここは後で削除
  root 'api/v1/posts#index'
end
