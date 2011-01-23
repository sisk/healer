require 'spec_helper'

describe BodyPart do
  should_have_column :name_en, :type => :string
  should_have_column :name_es, :type => :string
  should_validate_presence_of :name_en
  should_validate_inclusion_of :side, :in => %w(L R), :allow_nil => true, :allow_blank => true

  should_have_many :diagnoses
end

describe BodyPart, "#to_s" do
  context "English" do
    before(:each) do
      set_english
      @body_part = BodyPart.new(:name_en => "Lung")
    end
    it "returns its name" do
      @body_part.to_s.should == "Lung"
    end
    it "appends '(side)' if side is set" do
      @body_part.side = "L"
      @body_part.to_s.should == "Lung (L)"
    end
  end
  context "Spanish" do
    before(:each) do
      set_spanish
      @body_part = BodyPart.new(:name_en => "Lung")
    end
    it "returns its Spanish name if it exists" do
      @body_part.name_es = "Pulmonar"
      @body_part.to_s.should == "Pulmonar"
    end
    it "returns English if no Spanish equivalent is set" do
      @body_part.to_s.should == "Lung"
    end
    it "appends proper language '(side)' if side is set" do
      @body_part.side = "L"
      @body_part.to_s.should == "Lung (Z)"
      @body_part.side = "R"
      @body_part.to_s.should == "Lung (D)"
    end
  end
end

describe BodyPart, "#mirror" do
  before(:each) do
    @neck = BodyPart.new(:name_en => "Neck")
    @left_knee = BodyPart.new(:name_en => "Knee", :side => "L")
    @right_knee = BodyPart.new(:name_en => "Knee", :side => "R")
    @another_left_knee = BodyPart.new(:name_en => "Knee", :side => "L")
  end
  it "returns the bilateral part if one exists in all body parts" do
    @left_knee.stub(:all_body_parts).and_return([@left_knee, @right_knee, @neck])
    @left_knee.mirror.should == @right_knee
  end
  it "returns only one bilateral part if +1 exist" do
    @right_knee.stub(:all_body_parts).and_return([@left_knee, @right_knee, @another_left_knee])
    @right_knee.mirror.should == @left_knee
  end
  it "returns nil if no bilateral part exists" do
    @left_knee.stub(:all_body_parts).and_return([@left_knee, @neck])
    @left_knee.mirror.should be_nil
  end
end

describe BodyPart, "#has_mirror?" do
  it "is false if side is blank" do
    BodyPart.new(:side => nil).has_mirror?.should == false
  end
  it "is true if side is set" do
    BodyPart.new(:side => "R").has_mirror?.should == true
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

