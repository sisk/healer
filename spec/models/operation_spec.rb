require 'spec_helper'

describe Operation do
  should_have_column :procedure_id, :type => :integer
  should_have_column :patient_id, :type => :integer
  should_have_column :diagnosis_id, :type => :integer
  should_have_column :primary_surgeon_id, :type => :integer
  should_have_column :secondary_surgeon_id, :type => :integer
  should_have_column :anesthesiologist_id, :type => :integer
  should_have_column :date, :type => :date
  should_have_column :approach, :type => :string
  should_have_column :difficulty, :type => :integer, :default => 0
  should_have_column :graft, :type => :boolean
  should_have_column :notes, :type => :text
  should_have_column :ambulatory_order, :type => :string

  should_belong_to :procedure
  should_belong_to :patient
  should_belong_to :diagnosis
  should_belong_to :primary_surgeon
  should_belong_to :secondary_surgeon
  should_belong_to :anesthesiologist
  should_have_one :implant

  should_validate_presence_of :procedure
  should_validate_presence_of :patient
  should_validate_presence_of :date

  should_validate_numericality_of :difficulty
  should_validate_inclusion_of :difficulty, :in => Operation::difficulty_table.keys
  
  should_validate_inclusion_of :approach, :in => Operation::approaches, :allow_nil => true
  should_validate_inclusion_of :ambulatory_order, :in => Operation::ambulatory_orders, :allow_nil => true
  
end

describe Operation, ".approaches" do
  it "returns an array of the expected values" do
    Operation::approaches.should == ["Anterior","Lateral","Medial","Posterior","Dorsal","Lateral Transfibular"]
  end
end
describe Operation, ".ambulatory_orders" do
  it "returns an array of the expected values" do
    Operation::ambulatory_orders.should == ["Weight Bearing as Tolerated","Non-Weight Bearing","Partial Weight Bearing"]
  end
end
describe Operation, ".difficulty_table" do
  it "returns an indexed hash of the expected values" do
    Operation::difficulty_table.should == { 0 => "Routine", 1 => "Moderate", 2 => "Severe" }
  end
end

describe Operation, "#to_s" do
  it "returns the procedure name followed by a formatted date" do
    procedure = mock_model(Procedure)
    procedure.stub(:to_s).and_return("Derp")
    operation = Operation.new(:date => "2010-08-12".to_date, :procedure => procedure)
    operation.to_s.should == "Derp - 2010-08-12"
  end
end