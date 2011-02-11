class DiagnosesController < ApplicationController
  inherit_resources

  belongs_to :patient

  respond_to :html, :xml, :json
  before_filter :authenticate_user!
  filter_resource_access
  
  def create
    create! { patient_path(@patient) }
  end

  def update
    @diagnosis = Diagnosis.find(params[:id])
    if @diagnosis.update_attributes(params[:diagnosis])
      flash[:notice] = "Diagnosis updated."
    end
    respond_with(@diagnosis) do |format|
      format.html {redirect_to patient_path(@diagnosis.patient) }
      format.js { render :template => "diagnoses/update.js.erb", :layout => nil }
    end
  end

  def edit
    index! do |format|
      format.js { render :template => "diagnoses/edit.js.erb", :layout => nil }
    end
  end

  def destroy
    destroy! { patient_path(@patient) }
  end

end
