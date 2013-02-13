require "fileutils"

# TODO js: consider scoping this functionality to a trip
module Healer
  module Utility

    class S3Sync

      def pull_patient_photos
        pull("patients")
      end

      def push_patient_photos
        push("patients")
      end

      def pull_xray_photos
        pull("xrays")
      end

      def push_xray_photos
        push("xrays")
      end

      private

      def pull(asset)
        setup_directory_for(asset)
        system(pull_command_for(asset))
      end

      def push(asset)
        system(push_command_for(asset))
      end

      def assets
        %w(xrays patients)
      end

      def setup_directory_for(asset)
        FileUtils.mkdir_p("public/system/#{asset}")
      end

      def pull_command_for(asset)
        command = "s3cmd get #{default_options_for_s3cmd}"
        command << " s3://healer-production/#{asset}/ public/system/#{asset}"
      end

      def push_command_for(asset)
        command = "s3cmd put #{default_options_for_s3cmd}"
        command << " public/system/#{asset} s3://healer-production/#{asset}/"
      end

      def default_options_for_s3cmd
        "--delete-removed --skip-existing --recursive"
      end
    end

  end
end
