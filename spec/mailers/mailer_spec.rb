require "spec_helper"

describe Mailer do
  
  before(:each) do
    ActionMailer::Base.perform_deliveries = true  
    ActionMailer::Base.deliveries = []  
  end
  
  it "#case_added" do
    patient_case = mock_model(PatientCase, :to_s => "Herp", :created_by => "Someone", :patient => mock_model(Patient))
    mail = Mailer.case_added(patient_case).deliver
    ActionMailer::Base.deliveries.size.should == 1
  end

end
