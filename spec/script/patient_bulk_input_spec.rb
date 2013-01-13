#encoding: UTF-8
require 'spec_helper'
require 'patient_bulk_input'

def data
  [
    ["Name", "Gender", "Age", "Surgery", "Op Walk number", "Healer ID"],
    ["Celso Augusto Menéndez Morales", "M", "73", "BTKR", "12", ""],
    ["Sonia Amanda Rivas Ozuna", "F", "63", "BTKR", "10", ""],
    ["Carlos Antonio Guzman Samayoa", "M", "33", "LTKR", "63", ""],
    ["Jesus Moya Leonardo", "F", "72", "RTKR", "72", ""],
    ["Yenni Maricela Pérez", "F", "22", "RTHR with plate and screws", "19", ""],
    ["María Argelia Rivas Juárez", "F", "66", "BTHR", "37", ""],
    ["Deborah Vanesa Orellana Pedroza", "F", "35", "LTHR", "39", ""],
    ["Wendy Paola Lucas Guzmán", "F", "38", "BTHR", "19", ""],
    ["Gloria Marciana Alvarado Pinelo", "F",
    "82",
    "RTHR (but only RK x-ray in sleeve)",
    "58",
    ""],
    ["Arcely Juárez Pérez", "F", "66", "RTKR Revision (infection?)", "15", ""],
    ["José Antonio Garrido Balcarcel", "M", "28", "RTHR Revision", "46", ""]
  ]
end

describe PatientBulkInput do

  describe "#perform" do

    subject do
      PatientBulkInput.new(key)
    end

    let(:key) { "abcdefg" }
    let(:trip) { mock_model("Trip") }

    before do
      Trip.stub(:next).and_return([trip])
      subject.stub(:data).and_return(data)

      subject.perform
    end

    it "Adds new patients with proper names" do
      Patient.count.should == 11
      Patient.all.map(&:name).should include("Yenni Pérez")
    end

    it "Adds new cases" do
      PatientCase.count.should == 15
    end

    it "sets revision flags" do
      PatientCase.all.select{ |cg| cg.revision == true }.size.should == 2
    end

    it "joins up the right cases to the right patients" do
      PatientCase.first.patient.should == Patient.first
      PatientCase.last.patient.should == Patient.last
    end

    it "makes expected case groups" do
      CaseGroup.count.should == 11
      CaseGroup.all.select{ |cg| cg.bilateral? }.size.should == 4
    end

    it "authorizes all cases" do
      PatientCase.all.all?{ |pc| pc.authorized? }.should == true
    end

    it "sets notes" do
      PatientCase.all.map(&:notes).should include("with plate and screws")
      PatientCase.all.map(&:notes).should include("Revision (infection?)")
      PatientCase.all.map(&:notes).should include("(but only RK x-ray in sleeve)")
    end
  end

end