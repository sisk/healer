require 'spec_helper'

describe Procedure, "#to_s" do
  before(:each) do
    @procedure = Procedure.new(:name_en => "Dickie Doo-Doo Bone Saw Extravaganza")
  end
  context "English" do
    before(:each) do
      set_english
    end
    it "returns its name" do
      @procedure.to_s.should == "Dickie Doo-Doo Bone Saw Extravaganza"
    end
  end
  context "Spanish" do
    before(:each) do
      set_spanish
    end
    it "returns its Spanish name if it exists" do
      @procedure.name_es = "La Mejor"
      @procedure.to_s.should == "La Mejor"
    end
    it "returns English if no Spanish equivalent is set" do
      @procedure.to_s.should == "Dickie Doo-Doo Bone Saw Extravaganza"
    end
  end
end