class DiagnosesController < ApplicationController
  inherit_resources

  belongs_to :case, :parent_class => PatientCase

  respond_to :html, :xml, :json
  before_filter :authenticate_user!
  filter_resource_access

  def create
    # HACK: this shouldn't be necessary, but it's the only way xrays save right now. :-(
    # resource.patient ||= parent
    # resource.save if resource.valid?
    # /HACK
    # raise params.inspect
    create! do |success, failure|
      success.html { redirect_to parent_path, :notice => "Diagnosis added." }
      failure.html { redirect_to parent_path, :error => "Error adding diagnosis." }
    end
  end

  def update
    @diagnosis = Diagnosis.find(params[:id])
    if @diagnosis.update_attributes(params[:diagnosis])
      flash[:notice] = "Diagnosis updated."
    end
    respond_with(@diagnosis) do |format|
      format.html {redirect_to case_path(@diagnosis.patient_case) }
      format.js { render :template => "diagnoses/update.js.erb", :layout => nil }
    end
  end

  def edit
    edit! do |format|
      format.js { render :template => "diagnoses/edit.js.erb", :layout => nil }
    end
  end

  def destroy
    destroy! do |format|
      format.js { render :template => "diagnoses/destroy.js.erb", :layout => nil }
      format.html { redirect_to parent_path }
    end
  end

  def new
    @diagnosis = parent.build_diagnosis
  end

  private

end
