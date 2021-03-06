class FacilitiesController < ApplicationController
  inherit_resources
  
  before_filter :authenticate_user!
  filter_resource_access
  def create
    create! { facilities_path }
  end
  def update
    update! { facility_path(@facility) }
  end
end
