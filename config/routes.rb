Rails.application.routes.draw do

  require 'sidekiq/web'
  require 'admin_constraint'

  mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new
  root to: 'pages#show', id: 'home'

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

    namespace :statistics do
      resources :visits, only: [:index]
      get "/loyalty", to: "loyalty#show", as: :loyalty
    end
  end

  namespace :global_statistics do
    resources :visits, only: [:index]
  end

  # customers level accessed pages
  resources :user_sessions, only: [:create, :destroy]
  get 'login' => 'user_sessions#new'

  scope module: 'gowifi_auth' do
    get '/auth/:provider/callback' => 'omniauth#create'
    get '/auth/failure' => 'omniauth#failure'
  end

  scope '/wifi' do
    get ':place_id/loyalty' => 'loyalty#index', as: :loyalty

    scope ':slug' do
      get '/login' => 'gowifi#show', as: :gowifi_place
      get '/preview' => 'gowifi_previews#show'
      get '/sms/:id' => 'gowifi_sms#show', as: :gowifi_sms_confirmation

      scope module: 'gowifi_auth' do
        patch '/poll_enter' => 'poll#create'
        post '/by_password' => 'password#create'
        post '/by_sms' => 'sms#create'
        get '/simple_enter' => 'simple_enter#create'
        get '/advisor' => 'advisor#create'
      end

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

  get '/routers/:access_token/:file' => 'ovpn_certificates#index'

  # static pages
  get "/:id" => "pages#show", as: :page, format: false
end
