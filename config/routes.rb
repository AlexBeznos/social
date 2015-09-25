Rails.application.routes.draw do
  

  require 'sidekiq/web'
  require 'admin_constraint'

  mount Sidekiq::Web => '/sidekiq', :constraints => AdminConstraint.new

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
        resources :messages, except: [:index, :show] do
          member do
            get 'activate'
            get 'deactivate'
          end
        end
      end

      member do
        get 'edit_password' => 'users#edit_password'
        patch 'update_password' => 'users#update_password'
      end
    end
  end

  resources :users

  resources :places do
    resources :polls
    resources :messages, except: [:index, :show]
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
    get ':slug/login' => 'gowifi#show', as: :gowifi_place
    get ':place_id/welcome' => 'menu_items#welcome', as: :menu_items_list
    get ':slug/by_poll' => 'gowifi#enter_by_poll'
    patch ':slug/poll_enter' => 'gowifi#submit_poll'


    get ':slug/status' => 'gowifi_auth#redirect_after_auth'
    post ':slug/by_password' => 'gowifi_auth#enter_by_password'
    get ':slug/simple_enter' => 'gowifi_auth#simple_enter'
  end

  scope '/wifi/:place_id/' do
    resources :orders, only: [:index, :show]
  end

  resources :orders, only: :create, path: '/wifi/:place_id/orders/:id'

  get '/lang/:locale' => 'basic#set_locale', as: :set_locale

  post '/feedback' => 'basic#feedback', as: :feedback



  # static pages
  get "/:id" => "high_voltage/pages#show", :as => :page, :format => false

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
