require 'spec_helper'

describe Role, ".available" do
  it "returns a symbolized array of the expected values" do
    Role::available.should == [:standard, :doctor, :nurse, :scheduler, :anesthesiologist, :liaison, :admin, :superuser]
  end
end