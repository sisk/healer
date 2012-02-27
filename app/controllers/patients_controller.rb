class PatientsController < ApplicationController
  inherit_resources

  before_filter :authenticate_user!
  filter_resource_access

  def create
    create! { patients_path }
  end

  def edit
    edit! do |format|
      format.js { render :template => "patients/edit.js.erb", :layout => nil }
    end
  end

  def update
    update! do |format|
      format.html { redirect_to patient_path(resource), :notice => "Patient updated." }
      format.js { render :template => "patients/update.js.erb", :layout => nil }
    end
  end


  private #####################################################################

  def collection
    start = end_of_association_chain
    if params[:no_patient_cases]
      start = start.no_patient_cases
    end
    if params[:search].present?
      start = start.search(params[:search])
    end
    @patients ||= start.paginate(:page => params[:page], :per_page => 5)
  end

end
