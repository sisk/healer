require "spec_helper"
require "v1/patient_decorator"

describe V1::PatientDecorator do

  it "is a draper decorator" do
    decorator = V1::PatientDecorator.new(Patient.new)

    decorator.should be_kind_of(Draper::Decorator)
  end

  describe "#name" do
    it "delegates to model.name_full" do
      decorator = V1::PatientDecorator.new(build(:patient, name_full: "Arthur Fonzarelli"))

      decorator.name.should == "Arthur Fonzarelli"
    end
  end

  describe "#first_name" do
    it "returns the first space-separated value from name" do
      decorator = V1::PatientDecorator.new(Patient.new(name_full: "Arthur Fonzarelli Jr."))

      decorator.first_name.should == "Arthur"
    end
  end

end