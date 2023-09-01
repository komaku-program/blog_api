Rails.application.routes.draw do
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

  # ここは後で変更？削除する？
  root 'api/v1/posts#index'
end
