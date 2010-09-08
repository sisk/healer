class PatientsController < InheritedResources::Base
  before_filter :authenticate_user!
  filter_resource_access
  
  def create
    create! { patients_path }
  end
  def update
    update! { patients_path }
  end

private

  # def build_resource
  #   super
  #   @patient.risk_factors = [] unless @patient.risk_factors.present?
  #   @patient
  # end
  
end
