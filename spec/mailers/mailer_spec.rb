require "spec_helper"

describe Mailer do
  
  before(:each) do
    ActionMailer::Base.perform_deliveries = true  
    ActionMailer::Base.deliveries = []  
  end
  
  describe "#case_added" do
    it "send an email for new case" do
      patient_case = create(:patient_case)
      mail = Mailer.case_added(patient_case, "a@b.com").deliver

      ActionMailer::Base.deliveries.size.should == 1
    end
  end

end
