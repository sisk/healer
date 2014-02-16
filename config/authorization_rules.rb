authorization do
  role :guest do
    has_permission_on :trips, :to => [:show, :current]
    has_permission_on :users, :to => [:show, :edit, :update] do
      if_attribute :email => is { user.email }
    end
  end
  role :standard do
    includes :guest
    has_permission_on [:trips, :patients, :patient_cases, :implants, :operations, :xrays, :adverse_events], :to => [:view_only]
  end
  role :scheduler do
    has_permission_on :patients, :to => :authorize
    has_permission_on :trips, :to => :schedule
    has_permission_on :patient_cases, :to => [:certificate]
  end
  role :superuser do
    includes :scheduler
    has_permission_on [:trips, :facilities, :rooms, :users, :patients, :diseases, :risks, :risk_factors, :patient_cases, :implants, :operations, :procedures, :xrays, :adverse_events], :to => :everything
    has_permission_on [:trips], :to => [:users, :new_user, :summary_report, :day_report]
    has_permission_on :patient_cases, :to => [:authorize, :deauthorize, :unschedule, :review, :waiting, :bulk]
    has_permission_on [:diseases, :procedures, :risks, :rooms], :to => [:sort]
    has_permission_on :users, :to => [:administer]
  end
  role :admin do
    includes :scheduler
    has_permission_on [:patients, :diseases, :risks, :risk_factors, :patient_cases, :implants, :operations, :adverse_events, :xrays], :to => :everything
    has_permission_on [:trips], :to => [:view_only, :summary_report, :day_report, :current]
    has_permission_on [:patient_cases], :to => [:authorize, :deauthorize, :unschedule, :review, :waiting, :bulk]
    has_permission_on :users, :to => [:administer]
  end
  role :nurse do
    has_permission_on [:trips], :to => [:view_only, :summary_report, :day_report, :current]
    has_permission_on [:patients], :to => [:rest] do
      has_permission_on :risk_factors, :to => :everything
    end
    has_permission_on :patient_cases, :to => [:rest, :unschedule, :waiting, :bulk]
    has_permission_on :adverse_events, :to => [:rest]
  end
  role :doctor do
    includes :nurse
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