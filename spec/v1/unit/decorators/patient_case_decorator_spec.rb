require "spec_helper"
require "v1/patient_case_decorator"

describe V1::PatientCaseDecorator do

  describe "#title" do
    context "in English" do
      before(:each) do
        I18n.locale = :en
      end

      it "prefixes for revision case" do
        decorator = V1::PatientCaseDecorator.new(
          build(:patient_case, :anatomy => "knee", :side => "left", :revision => true)
        )

        decorator.title.should == "Knee Revision (L)"
      end

      it "does not prefix for non-revision case" do
        decorator = V1::PatientCaseDecorator.new(
          build(:patient_case, :anatomy => "knee", :side => "left", :revision => false)
        )

        decorator.title.should == "Knee (L)"
      end

      it "formats for unspecified anatomy" do
        decorator = V1::PatientCaseDecorator.new(
          build(:patient_case, :anatomy => nil)
        )

        decorator.title.should == "unspecified body part"
      end

      it "ignores side if nil" do
        decorator = V1::PatientCaseDecorator.new(
          build(:patient_case, :anatomy => "knee", :side => nil)
        )

        decorator.title.should == "Knee"
      end

    end

    context "in Spanish" do
      before(:each) do
        I18n.locale = :es
      end

      it "postfixes for revision case" do
        decorator = V1::PatientCaseDecorator.new(
          build(:patient_case, :anatomy => "hip", :side => "right", :revision => true)
        )

        decorator.title.should == "Cadera Revisada (D)"
      end

      it "does not postfix for non-revision case" do
        decorator = V1::PatientCaseDecorator.new(
          build(:patient_case, :anatomy => "hip", :side => "right", :revision => false)
        )

        decorator.title.should == "Cadera (D)"
      end

      it "formats for unspecified anatomy" do
        decorator = V1::PatientCaseDecorator.new(
          build(:patient_case, :anatomy => nil)
        )

        decorator.title.should == "parte del cuerpo no especificada"
      end

      it "ignores side if nil" do
        decorator = V1::PatientCaseDecorator.new(
          build(:patient_case, :anatomy => "knee", :side => nil)
        )

        decorator.title.should == "Rodilla"
      end
    end
  end

  describe "#anatomy" do
    context "in English" do
      before(:each) do
        I18n.locale = :en
      end

      it "returns body part and side abbreviated" do
        decorator = V1::PatientCaseDecorator.new(
          build(:patient_case, :anatomy => "hip", :side => "right")
        )

        decorator.anatomy.should == "Hip (R)"
      end

      it "ignores side if nil" do
        decorator = V1::PatientCaseDecorator.new(
          build(:patient_case, :anatomy => "hip", :side => nil)
        )

        decorator.anatomy.should == "Hip"
      end

      it "formats for unspecified anatomy" do
        decorator = V1::PatientCaseDecorator.new(
          build(:patient_case, :anatomy => nil)
        )

        decorator.anatomy.should == "unspecified body part"
      end
    end

    context "in Spanish" do
      before(:each) do
        I18n.locale = :es
      end

      it "returns body part and side abbreviated" do
        decorator = V1::PatientCaseDecorator.new(
          build(:patient_case, :anatomy => "knee", :side => "left")
        )

        decorator.anatomy.should == "Rodilla (I)"
      end

      it "ignores side if nil" do
        decorator = V1::PatientCaseDecorator.new(
          build(:patient_case, :anatomy => "hip", :side => nil)
        )

        decorator.anatomy.should == "Cadera"
      end

      it "formats for unspecified anatomy" do
        decorator = V1::PatientCaseDecorator.new(
          build(:patient_case, :anatomy => nil)
        )

        decorator.anatomy.should == "parte del cuerpo no especificada"
      end
    end
  end

end