class AdverseEventsController < ApplicationController
  inherit_resources

  respond_to :html, :xml, :json

  before_filter :authenticate_user!
  before_filter :setup_case, :only => [:index, :new, :edit, :show]
  filter_resource_access

  belongs_to :patient

  def new
    new! do |format|
      format.html
      format.js { render :template => "adverse_events/new.js.erb", :layout => nil }
    end
  end

  def create
    create! do |format|
      format.html { patient_adverse_events_path(parent) }
      format.js { render :template => "adverse_events/create.js.erb", :layout => nil }
    end
  end

  def destroy
    patient = Patient.find(params[:patient_id])
    @adverse_event = AdverseEvent.find(params[:id])

    if @adverse_event.destroy
      respond_to do |format|
        format.html { redirect_to patient_adverse_events_path(patient), :notice => "Event deleted." }
      end
    else
      respond_to do |format|
        format.html { redirect_to patient_adverse_events_path(patient), :notice => "Event could not be deleted." }
      end
    end
  end

  private #####################################################################

  def setup_case
    @patient_case = PatientCase.find_by_id(params[:case_id])
  end

  def build_resource
     super
     @adverse_event.entered_by ||= current_user
     @adverse_event.patient_id ||= parent.id
     @adverse_event.case_id ||= params[:case_id]
     @adverse_event
  end

end
