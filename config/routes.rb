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
  get 'faq', to: 'pages#faq'

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

  concern :commentable do
    resources :comments, shallow: true
  end
  resources :stories do
    member do
      delete :remove_image
      delete :remove_attachment
    end
  end
  resources :notices, concerns: :commentable
  delete :likes, to: 'likes#destroy'
  resources :likes

  post '/tinymce_assets', to: 'tinymce_assets#create'

  namespace :admin do
    root 'pages#home'
    resources :users do
      member do
        patch :add_admin
        delete :remove_admin
      end
    end
    resources :ideas
  end

  match '/404', to: 'errors#not_found', via: :all, as: :error_404
  match '/401', to: 'errors#unauthorized', via: :all, as: :error_401
  match '/403', to: 'errors#forbidden', via: :all, as: :error_403
  match '/500', to: 'errors#internal_server_error', via: :all, as: :error_500

end
