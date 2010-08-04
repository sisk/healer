class DiseasesController < InheritedResources::Base
  before_filter :authenticate_user!
  # FIXME turn back on when auth engine is fixed
  # filter_resource_access
  def create
    create! { diseases_path }
  end
  def update
    update! { diseases_path }
  end
  def sort
    #  called via Ajax when sorting in UI
    order = params[:disease]
    Disease.order(order)
    render :nothing => true
    logger.debug(params)
  end
end
