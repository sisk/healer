require 'spec_helper'

describe PhysicalTherapy do
  it "is a kind of PatientInteraction" do
    PhysicalTherapy.new.should be_a_kind_of(PatientInteraction)
  end
  should_have_column :distance_walked, :type => :string
  should_have_column :number_of_assistances, :type => :integer
  should_have_column :walker_used, :type => :boolean
  should_have_column :extension, :type => :string
  should_have_column :flexion, :type => :string
  should_have_column :abduction, :type => :string

  should_validate_numericality_of :number_of_assistances, :allow_nil => true
  should_validate_inclusion_of :number_of_assistances, :in => 0..10, :allow_nil => true

end
