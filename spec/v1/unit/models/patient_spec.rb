require "spec_helper"
require "patient"

describe Patient do

  it "is not valid without a full name" do
    p = Patient.new

    p.should_not be_valid
    p.should have(1).errors # TEMP: used to deprecate first/last validations
    p.should have(1).error_on(:name_full)
  end

end