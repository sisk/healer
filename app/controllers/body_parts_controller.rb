class BodyPartsController < InheritedResources::Base
  before_filter :authenticate_user!
  filter_resource_access
  def create
    create! { body_parts_path }
  end
  def update
    update! { body_parts_path }
  end
end
