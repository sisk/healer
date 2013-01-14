authorization do
  role :guest do
    has_permission_on :trips, :to => [:show]
    has_permission_on :users, :to => [:show, :edit] do
      if_attribute :user => is { user }
    end
  end
  role :superuser do
    has_permission_on [:trips, :facilities, :rooms, :users, :patients, :body_parts, :diseases, :risks, :risk_factors, :patient_cases, :implants, :operations, :procedures, :xrays, :adverse_events], :to => :everything
    has_permission_on [:trips], :to => [:users, :new_user, :reports]
    has_permission_on :patient_cases, :to => [:authorize, :deauthorize, :unschedule, :review, :waiting, :bulk]
    has_permission_on [:diseases, :procedures, :risks, :rooms], :to => [:sort]
  end
  role :admin do
    has_permission_on [:patients, :diseases, :risks, :risk_factors, :patient_cases, :implants, :operations, :adverse_events, :xrays], :to => :everything
    has_permission_on [:trips], :to => [:view_only, :reports]
    has_permission_on [:patient_cases], :to => [:authorize, :deauthorize, :unschedule, :review, :waiting, :bulk]
  end
  role :nurse do
    has_permission_on [:trips], :to => [:view_only, :reports]
    has_permission_on [:patients], :to => [:rest] do
      has_permission_on :risk_factors, :to => :everything
    end
    has_permission_on :patient_cases, :to => [:rest, :unschedule, :waiting, :bulk]
    has_permission_on :adverse_events, :to => [:rest]
  end
  role :doctor do
    includes :nurse
    # has_permission_on [:trips, :patients], :to => :browse_and_update
    has_permission_on :patient_cases, :to => [:authorize, :deauthorize]
  end
  role :liaison do
    has_permission_on [:trips], :to => [:index, :show]
    has_permission_on [:patients, :patient_cases, :risk_factors, :xrays], :to => :everything
    has_permission_on [:patient_cases], :to => [:waiting]
  end
end

privileges do
  privilege :everything do
    includes :index, :show, :new, :create, :edit, :update, :destroy
  end
  privilege :rest do
    includes :index, :new, :create, :show, :update, :edit, :destroy
  end
  privilege :browse_and_update do
    includes :index, :show, :edit, :update
  end
  privilege :view_only do
    includes :index, :show
  end
end