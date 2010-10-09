authorization do
  role :guest do
    has_permission_on :trips, :to => [:show]
    has_permission_on :users, :to => [:show, :edit] do
      if_attribute :user => is { user }
    end
  end
  role :superuser do
    has_permission_on [:trips, :facilities, :rooms, :users, :patients, :body_parts, :diagnoses, :diseases, :risks, :risk_factors, :registrations, :implants, :operations], :to => :everything
    has_permission_on :registrations, :to => [:authorize, :deauthorize]
  end
  role :admin do
    has_permission_on [:patients, :diseases, :diagnoses, :risks, :risk_factors, :registrations, :implants, :operations], :to => :everything
    has_permission_on [:trips], :to => :view_only
  end
  role :nurse do
    has_permission_on [:trips], :to => :view_only
    has_permission_on [:patients], :to => [:manage, :browse_and_update] do
      has_permission_on :risk_factors, :to => :everything
      has_permission_on :diagnoses, :to => :everything
    end
    has_permission_on :registrations, :to => [:manage, :browse_and_update]
  end
  role :doctor do
    includes :nurse
    # has_permission_on [:trips, :patients], :to => :browse_and_update
    has_permission_on [:diagnoses], :to => :browse_and_update
    has_permission_on :registrations, :to => [:authorize, :deauthorize]
  end
end

privileges do
  privilege :everything do
    includes :index, :show, :new, :create, :edit, :update, :destroy
  end
  privilege :manage do
    includes :new, :create, :read, :update, :delete
  end
  privilege :browse_and_update do
    includes :index, :show, :edit, :update
  end
  privilege :view_only do
    includes :index, :show
  end
end