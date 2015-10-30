Rails.application.routes.draw do
  root 'teams#index'

  resources :teams do
    collection do
      get :reset_stats
    end
  end

  resources :matches, only: [:edit, :update] do
    collection do
      post :play
      post :play_all
    end
  end
end
