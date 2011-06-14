require 'spec_helper'

describe PhysicalTherapy do
  it "is a kind of PatientInteraction" do
    PhysicalTherapy.new.should be_a_kind_of(PatientInteraction)
  end
  should_have_column :distance_walked, :type => :string
  should_have_column :additional_assistance, :type => :boolean
  should_have_column :severe_pain, :type => :boolean
  should_have_column :range_of_motion, :type => :boolean
  should_have_column :ambulation, :type => :boolean
  should_have_column :knee_extension, :type => :string
  should_have_column :knee_flexion, :type => :string
  should_have_column :hip_abduction, :type => :string

  should_have_column :patient_case_id, :type => :integer
  should_belong_to :patient_case

end