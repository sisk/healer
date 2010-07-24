class StaffController < InheritedResources::Base
  defaults :resource_class => User, :collection_name => 'users', :instance_name => 'user'
  # filter_resource_access

  before_filter :authenticate_user!

end
