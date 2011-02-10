class OperationsController < ApplicationController
  inherit_resources
  
  respond_to :html, :xml, :json
  belongs_to :registration, :diagnosis, :polymorphic => true
  filter_resource_access

  def index
    index! do |format|
      format.json {
        render :text => "{\"operations\" : #{@operations.to_json}}"
      }
    end
  end
  
  def create
    create! { edit_resource_url }
  end

  def update
    update! { parent_url }
  end

  def destroy
    destroy! { parent_url }
  end
  
  private
  
  # def begin_of_association_chain
  #   diagnosis
  # end
  
  def build_resource 
     super
     @operation.diagnosis ||= diagnosis
     @operation.body_part = @operation.diagnosis.try(:body_part)
     @operation.registration = @operation.diagnosis.try(:registration)
     @operation.patient = @operation.diagnosis.try(:patient)
     @operation.patient = @operation.diagnosis.try(:patient)
     @operation.date = Date.today if @operation.new_record?
     @operation
  end
  
  def diagnosis
    @diagnosis ||= Diagnosis.find(params[:diagnosis_id]) if params[:diagnosis_id].present?
  end
  
end
