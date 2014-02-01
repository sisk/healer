require "spec_helper"
require "appointment"

describe Operation do

  describe "#anatomy" do
    it "delegates to case's anatomy" do
      p_case = build(:patient_case, :anatomy => "knee")
      operation = Operation.new(:patient_case => p_case)

      operation.anatomy.should == "knee"
    end
  end

  describe "#build_implant" do
    it "returns the existing implant if already present" do
      implant = create(:implant)
      operation = Operation.new(:implant => implant)

      operation.build_implant.should == implant
    end

    it "returns a new KneeImplant if case anatomy is a knee" do
      p_case = create(:patient_case, :anatomy => "knee")
      operation = Operation.new(:patient_case => p_case)

      implant = operation.build_implant
      implant.should be_new_record
      implant.should be_a(KneeImplant)
    end

    it "returns a new HipImplant if case anatomy is a hip" do
      p_case = create(:patient_case, :anatomy => "hip")
      operation = Operation.new(:patient_case => p_case)

      implant = operation.build_implant
      implant.should be_new_record
      implant.should be_a(HipImplant)
    end

    it "returns a new generic Implant if case anatomy is not a knee or hip" do
      p_case = create(:patient_case, :anatomy => "foot")
      operation = Operation.new(:patient_case => p_case)

      implant = operation.build_implant
      implant.should be_new_record
      implant.should be_a(Implant)
    end
  end

end