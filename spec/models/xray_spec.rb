require 'spec_helper'

describe Xray do
  should_have_column :date_time, :type => :datetime
  should_have_column :taken_at, :type => :string
  should_have_column :photo_file_name, :type => :string
  should_have_column :photo_content_type, :type => :string
  should_have_column :photo_file_size, :type => :integer
  should_have_column :primary, :type => :boolean
  should_have_column :patient_case_id, :type => :integer
  should_have_column :diagnosis_id, :type => :integer

  # should_validate_presence_of :photo
  should_belong_to :operation
  should_belong_to :patient_case

end

describe Xray, "#to_s" do
  before(:each) do
    @xray = Xray.new
    @xray.stub_chain(:patient_case, :to_s).and_return("Derp")
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