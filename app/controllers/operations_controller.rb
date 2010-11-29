class OperationsController < InheritedResources::Base
  respond_to :html, :xml, :json
  belongs_to :trip

  def index
    index! do |format|
      format.json {
        render :text => "{\"operations\" : #{@operations.to_json}}"
      }
    end
  end

  def create
    create! { patient_path(@patient) }
  end

  def update
    update! { patient_path(@patient) }
  end

  def sort
    #  called via Ajax when sorting in UI
    order = params[:operation]
    Operation.order(order)
    render :nothing => true
  end
  
  private
  
  def build_resource 
     super
     @operation.diagnosis ||= diagnosis_by_param
     @operation.body_part = @operation.diagnosis.try(:body_part)
     @operation
  end
  
  def diagnosis_by_param
    Diagnosis.find(params[:diagnosis_id]) if params[:diagnosis_id].present?
  end
  
end
