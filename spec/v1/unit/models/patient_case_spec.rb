require "spec_helper"
require "patient_case"

describe PatientCase do

  ["ankle", "foot", "knee", "hip", nil].each do |anatomy|
    it "is valid if anatomy is #{anatomy}" do
      p_case = PatientCase.new(
        :anatomy => anatomy,
        :patient => build(:patient),
        :trip => build(:trip)
      )

      p_case.should be_valid
    end
  end

  it "is not valid if anatomy is invalid" do
    p_case = PatientCase.new(
      :anatomy => "elbow",
      :patient => build(:patient),
      :trip => build(:trip)
    )

    p_case.should_not be_valid
  end
end