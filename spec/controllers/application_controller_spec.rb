require 'spec_helper'

describe ApplicationController, "request_ipad?" do
  it "returns true if http user agent contains iPad" do
    controller.stub_chain(:request, :user_agent).and_return("iPad")
    controller.request_ipad?.should be_true
  end
  it "returns false" do
    controller.stub_chain(:request, :user_agent).and_return("")
    controller.request_ipad?.should be_false
  end
end
