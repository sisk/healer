authorization do
  role :guest do
    has_permission_on :trips, :to => [:index, :show]
  end
  role :admin do
    has_permission_on [:trips, :users, :patients], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
  end
end