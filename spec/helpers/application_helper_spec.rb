require 'spec_helper'

describe ApplicationHelper, "request_ipad?" do
  it "returns true if http user agent contains iPad" do
    helper.stub_chain(:request, :user_agent).and_return("iPad")
    helper.request_ipad?.should be_true
  end
  it "returns false" do
    helper.stub_chain(:request, :user_agent).and_return("")
    helper.request_ipad?.should be_false
  end
end
