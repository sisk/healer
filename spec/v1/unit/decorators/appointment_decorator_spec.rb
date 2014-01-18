require "spec_helper"
require "v1/appointment_decorator"

describe V1::AppointmentDecorator do

  before(:each) do
    if Trip.count == 0
      create(:trip)
    end
    @trip = Trip.first
  end

  describe "#title" do

    context "in English" do
      before(:each) do
        I18n.locale = :en
      end

      it "outputs unspecified value if no cases exist" do
        appointment = Appointment.new(:trip => @trip)
        decorator = V1::AppointmentDecorator.new(appointment)

        decorator.title.should == "unspecified body part"
      end

      it "delegates value for single joint, non-revision to case decorator" do
        appointment = Appointment.new(:trip => @trip)
        p_case = create(:patient_case,
                        :trip => @trip, :anatomy => "knee", :side => "left", :revision => false)
        appointment.patient_cases << p_case
        decorator = V1::AppointmentDecorator.new(appointment)
        V1::PatientCaseDecorator.should_receive(:new).with(p_case).and_return(double(:title => "Derp"))

        decorator.title.should == "Derp"
      end

      it "outputs expected value for single joint, with revision" do
        appointment = Appointment.new(:trip => @trip)
        p_case = create(:patient_case,
                        :trip => @trip, :anatomy => "knee", :side => "left", :revision => true)
        appointment.patient_cases << p_case
        decorator = V1::AppointmentDecorator.new(appointment)
        V1::PatientCaseDecorator.should_receive(:new).with(p_case).and_return(double(:title => "Revision"))

        decorator.title.should == "Revision"
      end

      it "outputs expected value for bilateral, non-revision" do
        appointment = Appointment.new(:trip => @trip)
        p_case1 = create(:patient_case,
                         :trip => @trip, :anatomy => "knee", :side => "left", :revision => false)
        p_case2 = create(:patient_case,
                         :trip => @trip, :anatomy => "knee", :side => "right", :revision => false)
        appointment.patient_cases << p_case1
        appointment.patient_cases << p_case2
        decorator = V1::AppointmentDecorator.new(appointment)

        decorator.title.should == "Knee (Bilateral)"
      end

      it "outputs expected value for bilateral, one revision" do
        appointment = Appointment.new(:trip => @trip)
        p_case1 = create(:patient_case,
                         :trip => @trip, :anatomy => "knee", :side => "left", :revision => true)
        p_case2 = create(:patient_case,
                         :trip => @trip, :anatomy => "knee", :side => "right", :revision => false)
        appointment.patient_cases << p_case1
        appointment.patient_cases << p_case2
        decorator = V1::AppointmentDecorator.new(appointment)

        V1::PatientCaseDecorator.should_receive(:new).with(p_case1).and_return(double(:title => "Herp"))
        V1::PatientCaseDecorator.should_receive(:new).with(p_case2).and_return(double(:title => "Derp"))

        decorator.title.should == "Herp, Derp"
      end

      it "outputs expected value for bilateral, two revisions" do
        appointment = Appointment.new(:trip => @trip)
        p_case1 = create(:patient_case,
                         :trip => @trip, :anatomy => "knee", :side => "left", :revision => true)
        p_case2 = create(:patient_case,
                         :trip => @trip, :anatomy => "knee", :side => "right", :revision => true)
        appointment.patient_cases << p_case1
        appointment.patient_cases << p_case2
        decorator = V1::AppointmentDecorator.new(appointment)

        decorator.title.should == "Knee Revision (Bilateral)"
      end
    end

    context "in Spanish" do
      before(:each) do
        I18n.locale = :es
      end

      it "outputs unspecified value if no cases exist" do
        appointment = Appointment.new(:trip => @trip)
        decorator = V1::AppointmentDecorator.new(appointment)

        decorator.title.should == "parte del cuerpo no especificada"
      end

      it "outputs expected value for bilateral, non-revision" do
        appointment = Appointment.new(:trip => @trip)
        p_case1 = create(:patient_case,
                         :trip => @trip, :anatomy => "knee", :side => "left", :revision => false)
        p_case2 = create(:patient_case,
                         :trip => @trip, :anatomy => "knee", :side => "right", :revision => false)
        appointment.patient_cases << p_case1
        appointment.patient_cases << p_case2
        decorator = V1::AppointmentDecorator.new(appointment)

        decorator.title.should == "Rodilla (Bilateral)"
      end

      it "outputs expected value for bilateral, two revisions" do
        appointment = Appointment.new(:trip => @trip)
        p_case1 = create(:patient_case,
                         :trip => @trip, :anatomy => "hip", :side => "left", :revision => true)
        p_case2 = create(:patient_case,
                         :trip => @trip, :anatomy => "hip", :side => "right", :revision => true)
        appointment.patient_cases << p_case1
        appointment.patient_cases << p_case2
        decorator = V1::AppointmentDecorator.new(appointment)

        decorator.title.should == "Cadera Revisada (Bilateral)"
      end
    end

  end

end