class RoomsController < ApplicationController
  inherit_resources
  
  before_filter :authenticate_user!
  filter_resource_access :collection => [:index, :sort]
  
  belongs_to :facility
  def create
    create! { facility_rooms_path(@facility) }
  end
  def update
    update! { facility_rooms_path(@facility) }
  end
  def destroy
    destroy! { facility_rooms_path(@facility) }
  end

  def sort
    params[:room].each_with_index do |id, index|
      Room.update_all(['display_order = ?', index + 1], ['id = ?', id.to_i])
    end
    render :nothing => true
  end

end
