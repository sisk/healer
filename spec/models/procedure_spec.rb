require 'spec_helper'

describe Procedure do
  should_have_column :base_name, :type => :string
  should_have_column :code, :type => :string
  should_have_column :display_order, :type => :integer
  
  should_validate_presence_of :base_name

  should_have_many :operations
end

describe Procedure, "#to_s" do
  it "returns base_name" do
    Procedure.new(:base_name => "Dickie Doo-Doo Bone Saw Extravaganza").to_s.should == "Dickie Doo-Doo Bone Saw Extravaganza"
  end
end