class OperationsController < InheritedResources::Base
  belongs_to :patient
  def create
    create! { patient_path(@patient) }
  end
  def update
    update! { patient_path(@patient) }
  end
end
