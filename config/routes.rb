Rails.application.routes.draw do


  require 'sidekiq/web'
  require 'admin_constraint'

  mount Sidekiq::Web => '/sidekiq', :constraints => AdminConstraint.new
  root to: 'pages#show', id: 'home'

  namespace :adm do
    root to: 'dashboard#index'
    get '/' => 'dashboard#index'
    resources :places, only: :index
    resources :users, :shallow => true do
      resources :places, except: :index do
        resources :styles, except: :index do
          member do
            patch 'remove_background'
          end
        end
      end

      member do
        get 'edit_password' => 'users#edit_password'
        patch 'update_password' => 'users#update_password'
      end
    end
  end

  resources :users do
    resources :notifications, only: [:index] do
        member do
          patch 'approve', to: 'notifications#approve'
          patch 'unapprove', to: 'notifications#unapprove'
        end
    end
  end
  resources :places do
    resources :auths, except: :index
    # resources :banners NOTE: uncomment when we will know what to do with this shit
    resources :stocks, except: :show
    resources :styles, except: :index
    resources :menu_items
    member do
      get 'guests'
      get 'birthdays'
      get 'settings'
    end
  end


  # customers level accessed pages
  resources :user_sessions, only: [:create, :destroy]
  get 'login' => 'user_sessions#new'

  get '/auth/:provider/callback' => 'gowifi_auth#omniauth' # omniauth customers authentication
  get '/auth/failure' => 'gowifi_auth#auth_failure'

  scope '/wifi' do
    get ':place_id/loyalty' => 'loyalty#index', as: :loyalty


    scope ':slug' do
      get "/scratchcard", to: "gowifi_scratchcard#show", as: :scratchcard
      get '/login' => 'gowifi#show', as: :gowifi_place
      get '/preview' => 'gowifi_previews#show'
      patch '/poll_enter' => 'gowifi_auth#submit_poll'
      post '/by_password' => 'gowifi_auth#enter_by_password'
      post '/by_sms' => 'gowifi_auth#enter_by_sms'
      get '/simple_enter' => 'gowifi_auth#simple_enter'
      get '/sms/:id' => 'gowifi_sms#show', as: :gowifi_sms_confirmation

      resources :gowifi_sms, only: :create do
        member do
          post 'resend' => 'gowifi_sms#resend'
        end
      end
    end
  end

  scope '/wifi/:place_id/' do
    resources :orders, only: [:index, :show]
  end

  resources :orders, only: :create, path: '/wifi/:place_id/orders/:id'

  get '/lang/:locale' => 'basic#set_locale', as: :set_locale

  post '/feedback' => 'basic#feedback', as: :feedback



  # static pages
  get "/:id" => "pages#show", as: :page, format: false
end
