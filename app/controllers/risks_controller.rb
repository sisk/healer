class RisksController < InheritedResources::Base
  before_filter :authenticate_user!
  filter_resource_access
  def create
    create! { risks_path }
  end
  def update
    update! { risks_path }
  end
  def sort
    # FIXME something is busted here.
    #  called via Ajax when sorting in UI
    order = params[:risk]
    Risk.order(order)
    render :nothing => true
  end
end
