class TripUsersController < ApplicationController
  
  inherit_resources
  belongs_to :trip
  
  respond_to :html, :json
  before_filter :authenticate_user!
  
  def index
    @existing_users = parent.users.sort_by(&:to_s)
    @available_users = (User.all - @existing_users).sort_by(&:to_s)
  end
  
  def create
    user = User.find(params[:user][:user_id])
    parent.users << user
    flash[:notice] = "#{user} added to #{trip_name(parent)}"
    redirect_to :back
  end
  
  def destroy
    user = User.find(params[:id])
    parent.users.delete(user)
    flash[:notice] = "#{user} removed from #{trip_name(parent)}"
    redirect_to :back
  end


  private ######################################################################

  def trip_name(trip)
    V1::TripDecorator.new(trip).name
  end
  
end
