class ProceduresController < InheritedResources::Base
  before_filter :authenticate_user!
  filter_resource_access
  def create
    create! { procedures_path }
  end
  def update
    update! { procedures_path }
  end
  def sort
    #  called via Ajax when sorting in UI
    order = params[:procedure]
    Procedure.order(order)
    render :nothing => true
  end
end
