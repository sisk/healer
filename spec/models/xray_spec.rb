require 'spec_helper'

describe Xray do
  should_have_column :date_time, :type => :datetime
  should_have_column :taken_at, :type => :string
  should_have_column :photo_file_name, :type => :string
  should_have_column :photo_content_type, :type => :string
  should_have_column :photo_file_size, :type => :integer
  should_have_column :primary, :type => :boolean

  # should_validate_presence_of :photo
  should_belong_to :diagnosis
  should_belong_to :operation

end

describe Xray, "#patient" do
  before(:each) do
    @xray = Xray.new()
  end
  it "returns the patient attached to diagnosis if set" do
    patient = mock_model(Patient)
    @xray.diagnosis = mock_model(Diagnosis, :patient => patient)
    @xray.patient.should == patient
  end
  it "returns the operation patient if set" do
    patient = mock_model(Patient)
    @xray.operation = mock_model(Operation, :patient => patient)
    @xray.patient.should == patient
  end
  it "returns nil by default" do
    @xray.patient.should == nil
  end
end

describe Xray, "#to_s" do
  before(:each) do
    @xray = Xray.new
    @xray.stub_chain(:patient, :to_s).and_return("Derp")
  end
  it "returns expected string if date_time is not set" do
    @xray.to_s.should == "X-ray: Derp"
  end
  it "returns expected string if date_time is set" do
    the_time = "2010-07-10 5:00pm".to_time
    @xray.date_time = the_time
    @xray.to_s.should == "X-ray: Derp - #{the_time.to_s}"
  end
end