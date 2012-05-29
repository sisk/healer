class AdverseEventsController < ApplicationController
  inherit_resources
  
  respond_to :html, :xml, :json

  before_filter :authenticate_user!
  before_filter :setup_case, :only => [:index, :new, :edit, :show]
  filter_resource_access

  belongs_to :patient

  def create
    create! { patient_adverse_events_path(parent) }
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

  # def create
  #   create! { patient_path(@patient) }
  # end
  # def update
  #   update! { patient_path(@patient) }
  # end
  # def destroy
  #   respond_to do |wants|
  #     wants.html do
  #       destroy! { edit_patient_path(@patient) }
  #     end
  #     wants.js do
  #       destroy! do
  #         render :nothing => true
  #         return
  #       end
  #     end
  #   end
  # end

end
