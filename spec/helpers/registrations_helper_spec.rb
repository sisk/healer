require 'spec_helper'

describe RegistrationsHelper, "#body_part_list" do
  it "outputs a formatted date string of body parts for its diagnoses" do
    registration = Registration.new(:diagnoses => [
      stub_model(Diagnosis, :body_part => stub_model(BodyPart, :to_s => "Knee (L)")),
      stub_model(Diagnosis, :body_part => stub_model(BodyPart, :to_s => "Knee (R)")),
    ])
    helper.body_part_list(registration).should == "Knee (L), Knee (R)"
  end
  it "outputs empty string if no diagnoses" do
    registration = Registration.new(:diagnoses => [])
    helper.body_part_list(registration).should == ""
  end
end
