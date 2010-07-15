class PatientsController < InheritedResources::Base
  before_filter :authenticate_user!
  
  def create
    create! { patients_path }
  end
  def update
    update! { patients_path }
  end
  
end
