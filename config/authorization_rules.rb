authorization do
  role :guest do
    has_permission_on :trips, :to => [:show]
    has_permission_on :users, :to => [:show, :edit] do
      if_attribute :user => is { user }
    end
  end
  role :admin do
    has_permission_on [:trips, :users, :patients, :body_parts, :diagnoses], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
  end
  role :nurse do
    has_permission_on [:trips], :to => [:index, :show]
    #has_permission_on [:diagnoses], :to => [:index, :show, :edit, :update]
    has_permission_on [:patients], :to => [:index, :show, :edit, :update] do
      has_permission_on :diagnoses, :to => [:index, :show, :create, :update, :edit, :destroy]
    end
  end
  role :doctor do
    include :nurse
    # has_permission_on [:trips, :patients], :to => [:index, :show, :edit, :update]
    has_permission_on [:diagnoses], :to => [:index, :show, :edit, :update]
  end
end