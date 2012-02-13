require 'spec_helper'

describe BodyPart do
  should_have_column :mirror_id, :type => :integer
  should_have_column :name_en, :type => :string
  should_have_column :name_es, :type => :string
  should_validate_presence_of :name_en
  should_validate_inclusion_of :side, :in => %w(L R), :allow_nil => true, :allow_blank => true

  should_belong_to :mirror
end

describe BodyPart, "#to_s" do
  before(:each) do
    @body_part = BodyPart.new(:name_en => "Lung")
    @body_part.stub(:display_name).and_return("Lung")
  end
  it "contains its display_name" do
    @body_part.to_s.should == "Lung"
  end
  context "English" do
    before(:each) do
      set_english
    end
    it "appends '(side)' if side is set" do
      @body_part.side = "L"
      @body_part.to_s.should == "Lung (L)"
    end
  end
  context "Spanish" do
    before(:each) do
      set_spanish
    end
    it "appends proper language '(side)' if side is set" do
      @body_part.side = "L"
      @body_part.to_s.should == "Lung (I)"
      @body_part.side = "R"
      @body_part.to_s.should == "Lung (D)"
    end
  end
end

describe BodyPart, "#display_name" do
  before(:each) do
    @body_part = BodyPart.new(:name_en => "Lung")
  end
  context "English" do
    before(:each) do
      set_english
    end
    it "returns its name" do
      @body_part.display_name.should == "Lung"
    end
  end
  context "Spanish" do
    before(:each) do
      set_spanish
    end
    it "returns its Spanish name if it exists" do
      @body_part.name_es = "Pulmonar"
      @body_part.display_name.should == "Pulmonar"
    end
    it "returns English if no Spanish equivalent is set" do
      @body_part.display_name.should == "Lung"
    end
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

