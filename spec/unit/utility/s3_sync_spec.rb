#encoding: UTF-8
require "spec_helper"
require "fileutils"

require "#{Rails.root}/utility/s3_sync"

module Healer::Utility

  describe S3Sync do

    before do
      S3Sync.any_instance.stub(:system) # neuter for unit test
    end

    context "patients" do
      describe "#pull_patient_photos" do

        it "uses s3cmd to pull patient photos" do
          expected_call = "s3cmd get --delete-removed --skip-existing --recursive"
          expected_call << " s3://healer-production/patients/ public/system/patients"

          subject.should_receive(:system).with(expected_call).once

          subject.pull_patient_photos
        end

        it "ensures the target directory for patient photos exists" do
          expected_dir = "public/system/patients"
          temporary_move = false

          if File.exists?(expected_dir)
            temporary_move = true
            FileUtils.mv(expected_dir, "#{expected_dir}.bak")
          end

          subject.pull_patient_photos

          File.exists?(expected_dir).should be_true

          if temporary_move
            FileUtils.rm_rf(expected_dir)
            FileUtils.mv("#{expected_dir}.bak", expected_dir)
          end

        end

      end

      describe "#push_patient_photos" do

        it "uses s3cmd to push patient photos" do
          expected_call = "s3cmd put --delete-removed --skip-existing --recursive"
          expected_call << " public/system/patients s3://healer-production/patients/"

          subject.should_receive(:system).with(expected_call)

          subject.push_patient_photos
        end

      end
    end

    context "x-rays" do
      describe "#pull_xray_photos" do

        it "uses s3cmd to pull xray photos" do
          expected_call = "s3cmd get --delete-removed --skip-existing --recursive"
          expected_call << " s3://healer-production/xrays/ public/system/xrays"

          subject.should_receive(:system).with(expected_call).once

          subject.pull_xray_photos
        end

        it "ensures the target directory for xray photos exists" do
          expected_dir = "public/system/xrays"
          temporary_move = false

          if File.exists?(expected_dir)
            temporary_move = true
            FileUtils.mv(expected_dir, "#{expected_dir}.bak")
          end

          subject.pull_xray_photos

          File.exists?(expected_dir).should be_true

          if temporary_move
            FileUtils.rm_rf(expected_dir)
            FileUtils.mv("#{expected_dir}.bak", expected_dir)
          end

        end

      end

      describe "#push_xray_photos" do

        it "uses s3cmd to push xray photos" do
          expected_call = "s3cmd put --delete-removed --skip-existing --recursive"
          expected_call << " public/system/xrays s3://healer-production/xrays/"

          subject.should_receive(:system).with(expected_call)

          subject.push_xray_photos
        end

      end
    end

  end

end