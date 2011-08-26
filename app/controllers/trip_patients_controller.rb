class TripPatientsController < ApplicationController

  inherit_resources
  defaults :resource_class => Patient, :collection_name => 'patients', :instance_name => 'patient'
  belongs_to :trip
  before_filter :authenticate_user!

end
