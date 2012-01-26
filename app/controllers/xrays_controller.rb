class XraysController < ApplicationController
  inherit_resources
  belongs_to :operation, :polymorphic => true, :optional => true
  belongs_to :patient_case, :parent_class => PatientCase, :polymorphic => true, :optional => true

  def new
    @xray = parent.xrays.build
    new! do |format|
      format.html
      format.js { render :template => "xrays/new.js.erb", :layout => nil }
    end
  end

  def index
    index! do |format|
      format.html { @xrays = parent.xrays }
      format.js { render :template => "xrays/index.js.erb", :layout => nil }
    end
  end

  def create
    create! do |format|
      format.html { redirect_to parent_path }
      format.js { render :template => "xrays/create.js.erb", :layout => nil }
    end
  end

  def update
    update! { parent_path }
  end

  def destroy
    destroy! do |format|
      format.js { render :template => "xrays/destroy.js.erb", :layout => nil }
      format.html { redirect_to :back }
    end
  end

private

  def parent
    # normally, this shouldn't be needed. however, IR doesn't seem to handle the polymorphism combined with parent_class.
    if params[:case_id]
      @parent ||= PatientCase.find(params[:case_id])
    else
      @parent ||= Operation.find(params[:operation_id])
    end
  end

  def parent_path
    # normally, this shouldn't be needed. however, IR doesn't seemto handle the polymorphism combined with parent_class.
    if params[:case_id]
      return case_path(PatientCase.find(params[:case_id]))
    else
      return operation_path(Operation.find(params[:operation_id]))
    end
  end

end
