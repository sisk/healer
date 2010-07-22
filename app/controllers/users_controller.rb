class UsersController < InheritedResources::Base
# class UsersController < ApplicationController

  before_filter :authenticate_user!
  # filter_resource_access

  before_filter :set_selectable_roles

  def create
    create! { users_path }
  end
  def update
    update! { users_path }
  end
  
private
  
  def set_selectable_roles
    @selectable_roles = Role::available
  end
  
end
