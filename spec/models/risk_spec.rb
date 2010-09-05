require 'spec_helper'

describe Risk do
  should_have_column :name, :type => :string
  should_have_column :display_order, :type => :integer

  should_validate_presence_of :name
  should_have_many :risk_factors
end

describe Risk, "#to_s" do
  it "returns name" do
    Risk.new(:name => "Steroids").to_s.should == "Steroids"
  end
end