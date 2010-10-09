require 'spec_helper'

describe Room do
  should_have_column :title, :type => :string
  should_have_column :location, :type => :string
  should_have_column :facility_id, :type => :integer
  should_have_column :notes, :type => :text

  should_belong_to :facility
  should_validate_presence_of :facility

  should_have_many :operations
end

describe Room, "#to_s" do
  it "returns the title" do
    Room.new(:title => "Derp").to_s.should == "Derp"
  end
end
