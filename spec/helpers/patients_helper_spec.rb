require 'spec_helper'

describe PatientsHelper, "patient_image" do
  before(:each) do
    @patient = Patient.new
    @patient.stub(:to_s).and_return("Joe Derp")
    
  end
  it "outputs photo thumbnail if set" do
    @patient.stub(:photo)
    @patient.photo.stub(:file?).and_return(true)
    @patient.photo.stub(:url).with(:thumb).and_return("/path/to/image.jpg")
    helper.patient_image(@patient).should == image_tag(@patient.photo.url(:thumb), :alt => "Photo of Joe Derp")
  end
  it "outputs generic silhouette for male if photo not set and gender is not known" do
    @patient.stub_chain(:photo, :file?).and_return(false)
    @patient.male = nil
    helper.patient_image(@patient).should == image_tag("male-generic.gif", :alt => "")
  end
  it "outputs generic silhouette for male if photo not set and gender is male" do
    @patient.stub_chain(:photo, :file?).and_return(false)
    @patient.male = true
    helper.patient_image(@patient).should == image_tag("male-generic.gif", :alt => "")
  end
  it "outputs generic silhouette for male if photo not set and gender is female" do
    @patient.stub_chain(:photo, :file?).and_return(false)
    @patient.male = false
    helper.patient_image(@patient).should == image_tag("female-generic.gif", :alt => "")
  end
end

describe PatientsHelper, "patient_gender" do
  before(:each) do
    @patient = Patient.new
  end
  it "outputs 'Unknown' if gender is not set" do
    @patient.male = nil
    helper.patient_gender(@patient).should == "Unknown"
  end
  it "outputs 'Male' if gender is male" do
    @patient.male = true
    helper.patient_gender(@patient).should == "Male"
  end
  it "outputs 'Female' if gender is not male" do
    @patient.male = false
    helper.patient_gender(@patient).should == "Female"
  end
end

describe PatientsHelper, "risk_factor_list" do
  before(:each) do
    @patient = Patient.new
  end
  it "outputs a blank string if no risks" do
    @patient.stub(:risk_factors).and_return([])
    helper.risk_factor_list(@patient).should == ""
  end
  it "outputs a comma-separated string of risks if any exist" do
    risk_factor1 = mock_model(RiskFactor)
    risk_factor1.stub(:to_s).and_return("Derp1")
    risk_factor2 = mock_model(RiskFactor)
    risk_factor2.stub(:to_s).and_return("Derp2")
    @patient.stub(:risk_factors).and_return([risk_factor1, risk_factor2])
    helper.risk_factor_list(@patient).should == "Derp1, Derp2"
  end
end

describe PatientsHelper, "free_text_list_to_array" do
  it "returns an empty array if string argument is nil" do
    helper.free_text_list_to_array(nil).should == []
  end
  it "returns an empty array if string argument is blank" do
    helper.free_text_list_to_array("").should == []
  end
  it "splits any string input by commas, with proper whitespace striping" do
    str = "a, b, c ,d , e , , ,"
    helper.free_text_list_to_array(str).should == ["a","b","c","d","e"]
  end
  it "splits any string input by newlines, with proper whitespace striping" do
    str = "a\n b\n c \n\n\nd \n e \n\n\n"
    helper.free_text_list_to_array(str).should == ["a","b","c","d","e"]
  end
  it "splits any string input by returns, with proper whitespace striping" do
    str = "a\r b\r c \rd \r e \r\r\r"
    helper.free_text_list_to_array(str).should == ["a","b","c","d","e"]
  end
  it "splits hybrid string input, with proper whitespace striping" do
    str = "a, b\r c ,d \r\n e \r,\n"
    helper.free_text_list_to_array(str).should == ["a","b","c","d","e"]
  end
end