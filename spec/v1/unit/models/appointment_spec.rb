require "spec_helper"
require "appointment"

describe Appointment do

  before(:each) do
    if Trip.count == 0
      create(:trip)
    end
    @trip = Trip.first
  end

  describe "#bilateral?" do
    it "is false if appointment has only one case" do
      appointment = Appointment.new(:trip => @trip)
      appointment.patient_cases << build(:patient_case, :trip => @trip)

      appointment.bilateral?.should be_false
    end

    it "is false if no two cases match anatomy" do
      appointment = Appointment.new
      appointment.patient_cases << build(
        :patient_case,
        :trip => @trip, :anatomy => "knee", :side => "left")
      appointment.patient_cases << build(
        :patient_case,
        :trip => @trip, :anatomy => "hip", :side => "right")

      appointment.bilateral?.should be_false
    end

    it "is false if two cases match anatomy, but have the same side" do
      appointment = Appointment.new
      appointment.patient_cases << build(
        :patient_case,
        :trip => @trip, :anatomy => "knee", :side => "left")
      appointment.patient_cases << build(
        :patient_case,
        :trip => @trip, :anatomy => "knee", :side => "left")

      appointment.bilateral?.should be_false
    end

    it "is true if two cases match anatomy and sides differ" do
      appointment = Appointment.new(:trip => @trip)
      appointment.patient_cases << build(
        :patient_case,
        :trip => @trip, :anatomy => "knee", :side => "right")
      appointment.patient_cases << build(
        :patient_case,
        :trip => @trip, :anatomy => "knee", :side => "left")

      appointment.bilateral?.should be_true
    end
  end

  # TODO js: seems like a weird edge case; decide if we want to test for it
  describe "#mixed_joint?" do
    it "is false if appointment has only one case"

    it "is false if all case anatomies match"

    it "is true if any case anatomies differ"
  end

end