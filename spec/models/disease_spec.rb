require 'spec_helper'

describe Procedure, "#to_s" do
  before(:each) do
    @disease = Disease.new(:name_en => "Dickie Doo-Doo Disease")
  end
  context "English" do
    before(:each) do
      set_english
    end
    it "returns its name" do
      @disease.to_s.should == "Dickie Doo-Doo Disease"
    end
  end
  context "Spanish" do
    before(:each) do
      set_spanish
    end
    it "returns its Spanish name if it exists" do
      @disease.name_es = "Nonononononononono!"
      @disease.to_s.should == "Nonononononononono!"
    end
    it "returns English if no Spanish equivalent is set" do
      @disease.to_s.should == "Dickie Doo-Doo Disease"
    end
  end
end
