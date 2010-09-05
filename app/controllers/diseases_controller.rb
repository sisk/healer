class DiseasesController < InheritedResources::Base
  # actions :all, :except => [ :sort ]
  before_filter :authenticate_user!
  filter_resource_access
  def create
    create! { diseases_path }
  end
  def update
    update! { diseases_path }
  end
  def sort
    # FIXME something is busted here. inherited_resources exception above doesn't sem to solve it.
    #  called via Ajax when sorting in UI
    logger.debug("-------------------XXXXXXXXXXXXX--------------------")
    order = params[:disease]
    Disease.order(order)
    render :nothing => true
  end
end
