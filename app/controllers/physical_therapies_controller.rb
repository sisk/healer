class PhysicalTherapiesController < ApplicationController
  inherit_resources
  belongs_to :patient_case
end
