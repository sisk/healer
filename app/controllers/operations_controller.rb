class OperationsController < ApplicationController
  inherit_resources
  
  respond_to :html, :xml, :json
  belongs_to :case, :parent_class => PatientCase, :singleton => true
  # This controller is used as a singleton resource. For some reason, declarative_authorization doesn't like the use of
  # filter_resource_access here when trying to call #show. Therefore, change it up a little for this controller.
  filter_access_to :all

  def index
    index! do |format|
      format.json {
        render :text => "{\"operations\" : #{@operations.to_json}}"
      }
    end
  end

  def new
    new!{ redirect_to resource_path and return if resource && !resource.new_record? }
  end

  def show
    show! {
      if resource
        if I18n.locale == :es
          # Patient certificate
          render :layout => "patient_certificate" and return
        end
      else
        flash[:error] = "No operation exists for this case."
        redirect_to parent_path and return
      end
    }
  end
  
  def create
    create! { edit_resource_url }
  end

  def update
    update! do |format|
      format.html {
        # if we got here via anything that responds to a patient_case, redirect to the patient_case path
        # if parent.respond_to?(:patient_case) && parent.patient_case.present?
        #   redirect_to trip_case_path(parent.patient_case.trip, parent.patient_case), :notice => "Operation updated."
        # else
        redirect_to case_operation_path(parent), :notice => "Operation updated."
        # end
      }
    end
  end

  def destroy
    destroy! { parent_url }
  end
  
  private
  
  def parent
    # normally, this shouldn't be needed. however, IR doesn't seem to handle the polymorphism combined with parent_class.
    @parent = PatientCase.find_by_id(params[:case_id])
  end

  def parent_path
    # normally, this shouldn't be needed. however, IR doesn't seemto handle the polymorphism combined with parent_class.
    return case_path(PatientCase.find(params[:case_id])) if params[:case_id]
  end

  def build_resource
     super
     @operation.date = Date.today if @operation.new_record?
     @operation
  end
  
end
