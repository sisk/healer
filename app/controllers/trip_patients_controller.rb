class TripPatientsController < ApplicationController

  inherit_resources
  defaults :resource_class => Patient, :collection_name => 'patients', :instance_name => 'patient'
  belongs_to :trip
  before_filter :authenticate_user!

  def index
    @body_part_names = parent.patient_cases.map(&:body_part).uniq.compact.map(&:name_en).uniq
    index!
  end

end