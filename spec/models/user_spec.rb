require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  it_should_behave_like 'authlogic_model'
  it{should validate_presence_of(:login)}

  it{should validate_presence_of(:name_first)}
  it{should validate_presence_of(:name_last)}
  
  # describe "to_s" do
  #   it "contains the user's last name if it exists" do
  #     User.new(:name_first => "", :name_last => "Detweiler", :email => "").to_s.should match(/Detweiler/)
  #   end
  #   it "contains the user's first name if it exists" do
  #     User.new(:name_first => "Max", :name_last => "", :email => "").to_s.should match(/Max/)
  #   end
  #   it "contains the user's email if it exists" do
  #     User.new(:name_first => "", :name_last => "", :email => "derp@derp.derp").to_s.should match(/derp@derp.derp/)
  #   end
  #   it "contains the user's email in brackets if it exists" do
  #     User.new(:name_first => "", :name_last => "", :email => "derp@derp.derp").to_s.should == "<derp@derp.derp>"
  #   end
  #   it "looks like 'First Last <email>' if all those components are in place" do
  #     User.new(:name_first => "Max", :name_last => "Detweiler", :email => "max@vontrapp.com").to_s.should == "Max Detweiler <max@vontrapp.com>"
  #   end
  # end
  
end
