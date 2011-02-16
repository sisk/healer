class XraysController < ApplicationController
  inherit_resources
  belongs_to :operation, :diagnosis, :polymorphic => true, :optional => true
  
  def create
    create! { parent_url }
  end

  def update
    update! { parent_url }
  end
  
  def destroy
    destroy! do |format|
      format.js { render :template => "xrays/destroy.js.erb", :layout => nil }
      format.html { redirect_to :back }
    end
  end
  
end
