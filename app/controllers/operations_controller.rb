class OperationsController < InheritedResources::Base
  belongs_to :patient
  def create
    create! { patient_path(@patient) }
  end
  def update
    update! { patient_path(@patient) }
  end
  
  private
  
  # def build_resource 
  #    super 
  #    @operation.build_implant(params[:implant]) 
  #    @operation
  # end 
  
end
