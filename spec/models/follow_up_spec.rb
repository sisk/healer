require 'spec_helper'

describe FollowUp do
  it "is a kind of PatientInteraction" do
    FollowUp.new.should be_a_kind_of(PatientInteraction)
  end
  should_have_and_belong_to_many :symptoms
end
