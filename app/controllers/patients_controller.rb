class PatientsController < InheritedResources::Base
  before_filter :authenticate_user!
  # FIXME turn back on when auth engine is fixed
  # filter_resource_access
  
  def create
    create! { patients_path }
  end
  def update
    update! { patients_path }
  end
  
end
