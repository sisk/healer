Healer::Application.routes.draw do

  # namespace :v1 do

  #   get "/trips", to: "trips#index"
  #   get "/trips/:nickname", to: "trips#show"
  #   get "/cases/new", to: "cases#new"#, as: "new_case_path"

  # end
  # ----------------------------------------------------------------------------
  # Below there be dragons

  # match "login" => "user_sessions#new"
  # match "logout" => "user_sessions#destroy"

  devise_for :users, :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register" }
  get 'easy_session' => 'sessions#easy'
  post 'easy_session_create' => 'sessions#create_easy'

  resources :users

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
    collection do
      get :current
    end
    member do
      get :summary_report
      get :day_report
    end
    resources :users, :controller => :trip_users
    resources :cases, :controller => :patient_cases do
      member do
        put :authorize, :deauthorize
      end
      collection do
        get :review, :waiting
        post :bulk
      end
    end
    resource :schedule, :controller => :schedule do
      member do
        put :sort_unscheduled, :sort_room
      end
    end
    resources :patients, :controller => :trip_patients do
      collection do
        get :room_signs
      end
    end
  end
  resources :patients do
    resources :risk_factors
    resources :cases, :controller => :patient_cases
    resources :adverse_events
  end
  resources :operations do
    resources :xrays
    resource :implant
  end
  resources :cases, :controller => :patient_cases do
    member do
      put :authorize, :deauthorize, :unschedule
      get :certificate
    end
    resources :xrays
    resource :operation
    resources :physical_therapies
  end
  resources :xrays


  resources :facilities do
    resources :rooms do
      collection do
        put :sort
      end
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action
  match 'test_error' => 'site#test_error'

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
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
