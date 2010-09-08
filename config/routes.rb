Healer::Application.routes.draw do |map|

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # match "login" => "user_sessions#new"
  # match "logout" => "user_sessions#destroy"

  devise_for :users, :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register" }
  resources :users

  resources :body_parts
  resources :diseases do
    collection do
      put :sort
    end
  end
  resources :risks do
    collection do
      put :sort
    end
  end
  resources :procedures do
    collection do
      put :sort
    end
  end
  resources :trips do
    resources :registrations do
      member do
        put :authorize, :deauthorize
      end
    end
    resource :staff, :controller => :staff
  end
  resources :patients do
    resources :risk_factors
    resources :diagnoses do
      resources :xrays
    end
    resources :operations do
      resources :xrays
    end
  end
  resources :operations do
    resource :implant
  end
  resources :registrations

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get :recent, :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "site#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
