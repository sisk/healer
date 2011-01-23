require 'spec_helper'

describe Disease do
  should_have_column :name_en, :type => :string
  should_have_column :name_es, :type => :string
  should_have_column :code, :type => :string
  should_have_column :display_order, :type => :integer

  should_validate_presence_of :name_en
  
  should_have_many :diagnoses
end

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
