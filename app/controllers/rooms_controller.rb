class RoomsController < InheritedResources::Base
  before_filter :authenticate_user!
  filter_resource_access
  belongs_to :facility
  def create
    create! { facility_path(@facility) }
  end
  def update
    update! { facility_path(@facility) }
  end
  def destroy
    destroy! { facility_path(@facility) }
  end
end
