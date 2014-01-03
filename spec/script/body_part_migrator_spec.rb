#encoding: UTF-8
require "spec_helper"
require "body_part_migrator"

describe BodyPartMigrator, "#perform" do

  before(:each) do
    if Trip.count == 0
      create(:trip)
    end
    @trip = Trip.first
  end
  
  it "converts a left knee case to expected string values" do
    bp_model = BodyPart.create!(:name_en => "Knee", :side => "L")
    p_case = create(:patient_case, :body_part => bp_model, :trip => @trip)
    p_case.should be_persisted

    PatientCase.count.should == 1
    p_case.anatomy.should be_nil
    p_case.side.should be_nil

    PatientCase.count.should == 1

    BodyPartMigrator.new.perform

    PatientCase.count.should == 1
    p_case.reload.anatomy.should == "knee"
    p_case.side.should == "left"
  end

  it "converts multiple cases" do
    bp_model1 = BodyPart.create!(:name_en => "Knee", :side => "L")
    bp_model2 = BodyPart.create!(:name_en => "Foot", :side => "R")
    p_case1 = create(:patient_case, :body_part => bp_model1, :trip => @trip)
    p_case2 = create(:patient_case, :body_part => bp_model2, :trip => @trip)
    p_case1.should be_persisted
    p_case2.should be_persisted

    PatientCase.count.should == 2

    BodyPartMigrator.new.perform

    PatientCase.count.should == 2
    p_case1.reload.anatomy.should == "knee"
    p_case1.side.should == "left"

    p_case2.reload.anatomy.should == "foot"
    p_case2.side.should == "right"
  end

  it "does not change a case with string values already present" do
    bp_model = BodyPart.create!(:name_en => "Hip", :side => "R")
    p_case = create(:patient_case, :body_part => bp_model, :anatomy => "knee", :side => "left", :trip => @trip)
    p_case.should be_persisted

    PatientCase.count.should == 1

    BodyPartMigrator.new.perform

    PatientCase.count.should == 1
    p_case.reload.anatomy.should == "knee"
    p_case.side.should == "left"
  end

end