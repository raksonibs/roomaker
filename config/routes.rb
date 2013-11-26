Roommaker::Application.routes.draw do
  get "asks/destroy"
  get "invites/destroy"
  get "welcome/index"
  resources :sessions, :only=> [:new,:create,:destroy]
  resources :users do
    resources :acceptedtasks
    resources :currenttasks
    resources :completedtasks
  end
  resources :pendingtasks
  #resources :groups
  root "welcome#index"
  get "/users/groups/:user_id"=> "groups#index"
  get "/groups/:user_id/new"=> "groups#new"
  resources :groups

  get "welcome_path" => "welcome#index"
  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]
  get '/sessions' => 'sessions#create'
  get '/users/:user_id/:id/yes' => "pendingtasks#yes"
  get '/users/:user_id/:id/no' => "pendingtasks#no"
  get '/users/:user_id/:id/delete' => "currenttasks#delete"
  get "/groups/"=> "groups#index"
  get "/users/:user_id/:id/verifY" => "currenttasks#delete"
  get "/users/:user_id/:id/:not" => "currenttasks#delete"
  get "/:user_id/:id/incomplete" => "currenttasks#incomplete"
  get "groups/:group_id/:user_id/leave" => "groups#leave"
  get "groups/:group_id/invite" => "groups#invite"
  post "/groups/:group_id/invitesearch" => "groups#invitesearch"
  resources :invites, :only=> [:destroy]
  get "groups/:group_id/ask" => "groups#ask"
  get "groups/:group_id/:asker_id" => "groups#join"
  resources :asks, :only=> [:destroy]
  
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
