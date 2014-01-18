require 'spec_helper'

describe Operation do
  should_have_column :procedure_id, :type => :integer
  should_have_column :primary_surgeon_id, :type => :integer
  should_have_column :secondary_surgeon_id, :type => :integer
  should_have_column :anesthesiologist_id, :type => :integer
  should_have_column :date, :type => :date
  should_have_column :start, :type => :datetime
  should_have_column :end, :type => :datetime
  should_have_column :approach, :type => :string
  should_have_column :difficulty, :type => :integer, :default => 0
  should_have_column :graft, :type => :boolean
  should_have_column :complete, :type => :boolean
  should_have_column :notes, :type => :text
  should_have_column :ambulatory_order, :type => :string
  should_have_column :room_id, :type => :integer
  should_have_column :patient_case_id, :type => :integer
  should_have_column :anesthesia_type, :type => :string
  should_have_column :peripheral_nerve_block_type, :type => :string

  should_belong_to :procedure
  should_belong_to :primary_surgeon
  should_belong_to :secondary_surgeon
  should_belong_to :anesthesiologist
  should_belong_to :room
  should_belong_to :patient_case

  should_have_one :implant
  should_have_one :knee_implant
  should_have_one :hip_implant

  should_have_many :xrays

  should_validate_presence_of :patient_case
  # should_validate_presence_of :date

  should_validate_numericality_of :difficulty
  should_validate_inclusion_of :difficulty, :in => Operation::difficulty_table.keys

  should_validate_inclusion_of :approach, :in => Operation::approaches, :allow_nil => true, :allow_blank => true
  should_validate_inclusion_of :ambulatory_order, :in => Operation::ambulatory_orders, :allow_nil => true, :allow_blank => true

end

describe Operation, ".approaches" do
  it "returns an array of the expected values" do
    Operation::approaches.should == ["Anterior","Lateral","Medial","Posterior","Dorsal","Planter","Lateral Transfibular"]
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

describe Operation, ".anesthsia_types" do
  it "returns an array of the expected values" do
    Operation::anesthsia_types.should == ["spinal","general"]
  end
end

describe Operation, ".peripheral_nerve_block_types" do
  it "returns an array of the expected values" do
    Operation::peripheral_nerve_block_types.should == ["femoral", "sciatic", "popliteal", "ankle", "none"]
  end
end

describe Operation, "#to_s" do
  before(:each) do
    @operation = Operation.new
    @body_part = stub_model(BodyPart, :side => "L")
    @body_part.stub(:to_s).and_return("BodyPart (L)")
    @procedure = stub_model(Procedure, :to_s => "Derp")
  end
  context "procedure is not set" do
    before(:each) do
      @operation.procedure = nil
    end
    it "returns '[Unspecified procedure]'" do
      @operation.to_s.should == "[Unspecified procedure]"
    end
  end
  context "procedure is set" do
    before(:each) do
      @operation.procedure = @procedure
    end
    it "Uses the procedure string" do
      @operation.stub(:body_part)
      @operation.to_s.should == "Derp"
    end
  end
end

describe Operation, "#display_xray" do
  before(:each) do
    @operation = Operation.new
    @x1 = stub_model(Xray, :primary => nil, :photo_file_name => "1")
    @x2 = stub_model(Xray, :primary => false, :photo_file_name => "2")
    @x3 = stub_model(Xray, :primary => true, :photo_file_name => "3")
    @x4 = stub_model(Xray, :primary => true, :photo_file_name => "4")
  end
  it "returns nil if no xrays" do
    @operation.display_xray.should be_nil
  end
  it "returns the first xray if only one exists" do
    @operation.xrays = [@x1]
    @operation.display_xray.should == @x1
  end
  it "returns the first xray if > 1 exist, but none are primary" do
    @operation.xrays = [@x1, @x2]
    @operation.display_xray.should == @x1
  end
  it "returns the first primary xray found" do
    # FIXME - breaking spec. dunno why.
    @operation.xrays = [@x1, @x2, @x3, @x4]
    @operation.display_xray.should == @x3
  end
end