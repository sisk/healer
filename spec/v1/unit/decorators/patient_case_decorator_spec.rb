# encoding: UTF-8
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

  describe "#patient" do
    it "delegates to the patient name" do
      decorator = V1::PatientCaseDecorator.new(
        build(:patient_case, :patient => create(:patient, :name_full => "Merrill Ritter"))
      )

      decorator.patient.should == "Merrill Ritter"
    end
  end

  describe "#procedure" do
    it "is nil if no operation present" do
      decorator = V1::PatientCaseDecorator.new(build(:patient_case))

      decorator.procedure.should be_nil
    end

    context "in English" do
      before(:each) do
        I18n.locale = :en
      end

      it "delegates to the operation's procedure" do
        operation = create(:operation,
          :procedure => create(
            :procedure, :name_en => "derp"))
        decorator = V1::PatientCaseDecorator.new(
          create(:patient_case, :operation => operation))

        decorator.procedure.should == "derp"
      end

      it "is 'unspecified' if operation has no procedure" do
        operation = create(:operation, :procedure => nil)
        decorator = V1::PatientCaseDecorator.new(
          build(:patient_case, :operation => operation)
        )

        decorator.procedure.should == "[Unspecified procedure]"
      end
    end

    context "in Spanish" do
      before(:each) do
        I18n.locale = :es
      end

      it "delegates to the operation's procedure in Spanish" do
        operation = create(:operation,
          :procedure => create(
            :procedure, :name_en => "derp",
                        :name_es => "el derp"))
        decorator = V1::PatientCaseDecorator.new(
          create(:patient_case, :operation => operation))

        decorator.procedure.should == "el derp"
      end

      it "uses English name if no Spanish present" do
        operation = create(:operation,
          :procedure => create(
            :procedure, :name_en => "derp"))
        decorator = V1::PatientCaseDecorator.new(
          create(:patient_case, :operation => operation))

        decorator.procedure.should == "derp"
      end

      it "is 'unspecified' if operation has no procedure" do
        operation = create(:operation, :procedure => nil)
        decorator = V1::PatientCaseDecorator.new(
          build(:patient_case, :operation => operation)
        )

        decorator.procedure.should == "[Operación no especificada]"
      end
    end
  end

  describe "#operation_date" do
    it "is nil if no operation present" do
      decorator = V1::PatientCaseDecorator.new(build(:patient_case))

      decorator.operation_date.should be_nil
    end

    context "in English" do
      before(:each) do
        I18n.locale = :en
      end

      it "outputs date in M/D/Y format" do
        operation = create(:operation, :date => Date.parse("1975-05-28"))
        decorator = V1::PatientCaseDecorator.new(
          create(:patient_case, :operation => operation))

        decorator.operation_date.should == "05/28/1975"
      end

      it "is 'unspecified' if operation has no date" do
        operation = create(:operation)
        decorator = V1::PatientCaseDecorator.new(
          build(:patient_case, :operation => operation)
        )

        decorator.operation_date.should == "[Date not specified]"
      end
    end

    context "in Spanish" do
      before(:each) do
        I18n.locale = :es
      end

      it "outputs date in D-M-Y format" do
        operation = create(:operation, :date => Date.parse("1975-05-28"))
        decorator = V1::PatientCaseDecorator.new(
          create(:patient_case, :operation => operation))

        decorator.operation_date.should == "28-05-1975"
      end

      it "is 'unspecified' if operation has no date" do
        operation = create(:operation)
        decorator = V1::PatientCaseDecorator.new(
          build(:patient_case, :operation => operation)
        )

        decorator.operation_date.should == "[Fecha no especificada]"
      end
    end
  end

  describe "#xrays" do
    it "returns array of all case xrays by default" do
      patient_case = create(:patient_case)
      x1 = create(:pre_op_xray, :patient_case => patient_case)
      x2 = create(:post_op_xray, :patient_case => patient_case)

      decorator = V1::PatientCaseDecorator.new(patient_case)

      decorator.xrays.should =~ [x1, x2]
    end

    it "returns only primary x-rays if argument present" do
      patient_case = create(:patient_case)
      x1 = create(:pre_op_xray, :patient_case => patient_case)
      x2 = create(:pre_op_xray, :patient_case => patient_case, :primary => true)
      x3 = create(:pre_op_xray, :patient_case => patient_case)

      decorator = V1::PatientCaseDecorator.new(patient_case)

      decorator.xrays(:primary => true).should == [x2]
    end

    it "returns only pre-op x-rays if argument present" do
      patient_case = create(:patient_case)
      x1 = create(:pre_op_xray, :patient_case => patient_case)
      x2 = create(:pre_op_xray, :patient_case => patient_case, :operation_id => 4)
      x3 = create(:pre_op_xray, :patient_case => patient_case)

      decorator = V1::PatientCaseDecorator.new(patient_case)

      decorator.xrays(:pre_op => true).should =~ [x1, x3]
    end

    it "returns only post-op x-rays if argument present" do
      patient_case = create(:patient_case)
      x1 = create(:pre_op_xray, :patient_case => patient_case)
      x2 = create(:pre_op_xray, :patient_case => patient_case, :operation_id => 4)
      x3 = create(:pre_op_xray, :patient_case => patient_case)

      decorator = V1::PatientCaseDecorator.new(patient_case)

      decorator.xrays(:post_op => true).should =~ [x2]
    end
  end

end