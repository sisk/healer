require "spec_helper"
require "v1/patient_decorator"

describe V1::PatientDecorator do

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

  describe "#id" do
    it "delegates to model.id" do
      patient = create(:patient, name_full: "Arthur Fonzarelli")
      decorator = V1::PatientDecorator.new(patient)

      decorator.id.should == patient.id
    end
  end

end