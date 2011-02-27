class XraysController < ApplicationController
  inherit_resources
  belongs_to :operation, :diagnosis, :polymorphic => true, :optional => true
  
  def index
    index! do |format|
      format.html { redirect_to patient_path(@diagnosis.patient) }
      # format.js { render :template => "xrays/index.js.erb", :layout => nil }
    end
  end
  
  def create
    create! { :back }
  end

  def update
    update! { :back }
  end
  
  def destroy
    destroy! do |format|
      format.js { render :template => "xrays/destroy.js.erb", :layout => nil }
      format.html { redirect_to :back }
    end
  end
  
end
