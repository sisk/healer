require 'spec_helper'

describe PhysicalTherapy do
  it "is a kind of PatientInteraction" do
    PhysicalTherapy.new.should be_a_kind_of(PatientInteraction)
  end
end