authorization do
  role :guest do
    has_permission_on :trips, :to => [:show]
    # has_permission_on :users, :to => [:show, :edit] do
    #   if_attribute :user => is { user }
    # end
  end
  role :admin do
    has_permission_on [:trips, :users, :patients], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
  end
end