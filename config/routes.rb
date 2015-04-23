Rails.application.routes.draw do

  namespace :adm do
    root to: 'dashboard#index'
    get '/' => 'dashboard#index'
    resources :users do
      resources :places, except: :index do
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


  # app users log in level pages
  root to: 'dashboard#index'
  get '/' => 'dashboard#index'

  # consumers level accessed pages
  resources :user_sessions, only: [:create, :destroy]
  get 'login' => 'user_sessions#new'

  get '/auth/:provider/callback' => 'gowifi#omniauth' # omniauth consumers authentication

  scope '/places' do
    get ':slug' => 'gowifi#show', as: :gowifi_place
    get ':slug/auth/:network' => 'gowifi#authorize', as: :gowifi_request
    get '/no_place' => 'gowifi#no_place', as: :gowifi_no_place
  end

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
