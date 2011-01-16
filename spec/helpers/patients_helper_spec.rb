require 'spec_helper'

describe PatientsHelper, "patient_image" do
  before(:each) do
    @patient = Patient.new
    @patient.stub(:to_s).and_return("Joe Derp")
    @patient.stub(:displayed_photo).with(:thumb).and_return("/path/to/photo")
  end
  it "outputs image tag with alt" do
    helper.patient_image(@patient).should == image_tag("/path/to/photo", :alt => "Photo of Joe Derp", :class => "patient_image")
  end
end

describe PatientsHelper, "patient_gender" do
  before(:each) do
    @patient = Patient.new
  end
  it "outputs 'Unknown' if patient is nil" do
    helper.patient_gender(nil).should == "Unknown"
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

describe PatientsHelper, "birth_date_and_age" do
  it "returns 'Unknown' if patient is nil" do
    helper.birth_date_and_age(nil).should == "Unknown"
  end
  it "returns 'Unknown' if birth date is not set" do
    patient = Patient.new
    helper.birth_date_and_age(patient).should == "Unknown"
  end
  it "returns formatted date with calculated age if birth date is set" do
    time_now = "2010-09-01".to_time
    Time.stub(:now).and_return(time_now)
    patient = Patient.new(:birth => "1975-05-28".to_date)
    helper.birth_date_and_age(patient).should == "1975-05-28 (Age 35)"
  end
end

describe PatientsHelper, "patient_height" do
  it "returns 'Unknown' if height_cm is not set" do
    patient = Patient.new
    helper.patient_height(patient).should == "Unknown"
  end
  it "returns stated metric amount if US param is absent" do
    patient = Patient.new(:height_cm => 6.25)
    helper.patient_height(patient).should == "6.25 cm"
  end
  it "returns stated metric amount if US param is false" do
    patient = Patient.new(:height_cm => 6.25)
    helper.patient_height(patient, false).should == "6.25 cm"
  end
  it "returns rounded US amount if US param is true" do
    # 1 centimeter = 0.393700787 inches
    patient = Patient.new(:height_cm => 6.25)
    raw_conversion = 6.25 * 0.393700787
    the_round = (raw_conversion * 100).round.to_f / 100
    helper.patient_height(patient, true).should == "#{the_round} in"
  end
end

describe PatientsHelper, "patient_weight" do
  it "returns 'Unknown' if weight_kg is not set" do
    patient = Patient.new
    helper.patient_weight(patient).should == "Unknown"
  end
  it "returns stated metric amount if US param is absent" do
    patient = Patient.new(:weight_kg => 6.25)
    helper.patient_weight(patient).should == "6.25 kg"
  end
  it "returns stated metric amount if US param is false" do
    patient = Patient.new(:weight_kg => 6.25)
    helper.patient_weight(patient, false).should == "6.25 kg"
  end
  it "returns rounded US amount if US param is true" do
    # 1 kilogram = 2.20462262 pounds
    patient = Patient.new(:weight_kg => 6.25)
    raw_conversion = 6.25 * 2.20462262
    the_round = (raw_conversion * 100).round.to_f / 100
    helper.patient_weight(patient, true).should == "#{the_round} lb"
  end
end