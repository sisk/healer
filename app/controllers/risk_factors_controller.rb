class RiskFactorsController < ApplicationController
  inherit_resources
  
  respond_to :html, :xml, :json
  respond_to :js, :only => :destroy
  before_filter :authenticate_user!
  filter_resource_access

  belongs_to :patient

  def create
    create! { patient_path(@patient) }
  end
  def update
    update! { patient_path(@patient) }
  end
  def destroy
    respond_to do |wants|
      wants.html do
        destroy! { edit_patient_path(@patient) }
      end
      wants.js do
        destroy! do
          render :nothing => true
          return
        end
      end
    end
  end

end

