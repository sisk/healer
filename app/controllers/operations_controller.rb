class OperationsController < InheritedResources::Base
  respond_to :html, :xml, :json
  belongs_to :diagnosis
  filter_resource_access

  def index
    index! do |format|
      format.json {
        render :text => "{\"operations\" : #{@operations.to_json}}"
      }
    end
  end

  def create
    create! { diagnosis_operation_path(diagnosis,@operation) }
  end

  def update
    update! { diagnosis_operation_path(diagnosis,@operation) }
  end

  private
  
  def build_resource 
     super
     @operation.diagnosis ||= diagnosis
     @operation.body_part = @operation.diagnosis.try(:body_part)
     @operation.patient = @operation.diagnosis.try(:patient)
     @operation
  end
  
  def diagnosis
    @diagnosis ||= Diagnosis.find(params[:diagnosis_id]) if params[:diagnosis_id].present?
  end
  
end
