require 'spec_helper'

describe RegistrationsHelper, "#body_part_list" do
  before(:each) do
    @left_knee = stub_model(BodyPart, :to_s => "Knee (L)", :name => "Knee")
    @right_knee = stub_model(BodyPart, :to_s => "Knee (R)", :name => "Knee")
    @right_hip = stub_model(BodyPart, :to_s => "Hip (R)", :name => "Hip")
  end
  it "outputs a formatted date string of body parts for its diagnoses" do
    registration = Registration.new(:diagnoses => [
      stub_model(Diagnosis, :body_part => @left_knee),
      stub_model(Diagnosis, :body_part => @right_knee),
    ])
    helper.body_part_list(registration).should == "Knee (L), Knee (R)"
  end
  it "outputs empty string if no diagnoses" do
    registration = Registration.new(:diagnoses => [])
    helper.body_part_list(registration).should == ""
  end
  it "outputs bilateral if registration is likely bilateral and body parts are the same" do
    registration = Registration.new(:likely_bilateral => true, :diagnoses => [
      stub_model(Diagnosis, :body_part => @left_knee),
      stub_model(Diagnosis, :body_part => @right_knee),
    ])
    helper.body_part_list(registration).should == "Knee (Bilateral)"
  end
  it "separates bilateral from non-bilateral parts" do
    registration = Registration.new(:likely_bilateral => true, :diagnoses => [
      stub_model(Diagnosis, :body_part => @left_knee),
      stub_model(Diagnosis, :body_part => @right_knee),
      stub_model(Diagnosis, :body_part => @right_hip),
    ])
    helper.body_part_list(registration).should == "Knee (Bilateral), Hip (R)"
  end
end