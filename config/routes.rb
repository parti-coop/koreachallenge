Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'user/omniauth_callbacks'
  }

  root 'pages#home'
  get 'terms', to: 'pages#terms'
  get 'privacy', to: 'pages#privacy'
  get 'about', to: 'pages#about'
  get 'intro', to: 'pages#intro'
  get 'schedule', to: 'pages#schedule'
  get 'judge', to: 'pages#judge'

  delete :cancel_current_user, to: 'users#cancel'
  delete :confirm_user, to: 'users#confirm'
  post 'users/confirm', to: 'users#confirm'
  get 'users/confirm_form', to: 'users#confirm_form'

  resources :ideas do
    member do
      get :download_attachment
      delete :remove_attachment
    end
  end

  namespace :admin do
    get 'home', to: 'pages#home'
    resources :users
  end

  match '/404', to: 'errors#not_found', via: :all, as: :error_404
  match '/401', to: 'errors#unauthorized', via: :all, as: :error_401
  match '/403', to: 'errors#forbidden', via: :all, as: :error_403
  match '/500', to: 'errors#internal_server_error', via: :all, as: :error_500

end
