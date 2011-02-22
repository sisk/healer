require 'spec_helper'

describe Procedure do
  should_have_column :name_en, :type => :string
  should_have_column :name_es, :type => :string
  should_have_column :code, :type => :string
  should_have_column :display_order, :type => :integer
  
  should_validate_presence_of :name_en
  should_validate_uniqueness_of :name_en

  should_have_many :operations
end

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