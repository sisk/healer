require 'spec_helper'

describe PatientInteraction do
  it_has_the_attribute :notes, :type => :text
  it{should belong_to(:patient)}
  it{should belong_to(:provider)}
  it{should validate_presence_of(:patient_id)}
end
