require 'spec_helper'

describe BodyPart do
  should_have_column :name, :type => :string
  should_validate_presence_of :name
  should_validate_inclusion_of :side, :in => %w(L R), :allow_nil => true, :allow_blank => true

  should_have_many :diagnoses
end

describe BodyPart, "#to_s" do
  it "returns its name" do
    @body_part = BodyPart.new(:name => "Spleen")
    @body_part.to_s.should == "Spleen"
  end
  it "appends '(side)' if side is set" do
    @body_part = BodyPart.new(:name => "Lung", :side => "L")
    @body_part.to_s.should == "Lung (L)"
  end
end

describe BodyPart, "#mirror" do
  before(:each) do
    @neck = BodyPart.new(:name => "Neck")
    @left_knee = BodyPart.new(:name => "Knee", :side => "L")
    @right_knee = BodyPart.new(:name => "Knee", :side => "R")
    @another_left_knee = BodyPart.new(:name => "Knee", :side => "L")
  end
  it "returns the bilateral part if one exists" do
    BodyPart.stub(:all).and_return([@left_knee, @right_knee, @neck])
    @left_knee.stub(:all_body_parts).and_return([@left_knee, @right_knee, @neck])
    @left_knee.mirror.should == @right_knee
  end
  it "returns only one bilateral part if +1 exist" do
    BodyPart.stub(:all).and_return([@left_knee, @right_knee, @another_left_knee])
    @right_knee.mirror.should == @left_knee
  end
  it "returns nil if no bilateral part exists" do
    BodyPart.stub(:all).and_return([@left_knee, @neck])
    @left_knee.mirror.should be_nil
  end
end

# == Schema Information
#
# Table name: body_parts
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

