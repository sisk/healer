class StaffController < ApplicationController
  inherit_resources
  
  defaults :resource_class => User, :collection_name => 'staff', :instance_name => 'staff'
  belongs_to :trip
  # filter_resource_access

  before_filter :authenticate_user!

end
