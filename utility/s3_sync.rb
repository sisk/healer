require "fileutils"

# TODO js: consider scoping this functionality to a trip
module Healer
  module Utility

    class S3Sync

      ASSETS_ROOT = "public/system"

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


      private ##################################################################

      def pull(asset)
        setup_directory_for(asset)
        system(pull_command_for(asset))
      end

      def push(asset)
        system(push_command_for(asset))
      end

      def setup_directory_for(asset)
        FileUtils.mkdir_p("#{ASSETS_ROOT}/#{asset}")
      end

      def pull_command_for(asset)
        command = "s3cmd#{custom_config_option} get #{default_options_for_s3cmd}"
        command << " s3://#{s3_bucket}/#{asset}/ #{ASSETS_ROOT}/#{asset}"
      end

      def push_command_for(asset)
        command = "s3cmd#{custom_config_option} sync #{default_options_for_s3cmd}"
        command << " #{ASSETS_ROOT}/#{asset}/ s3://#{s3_bucket}/#{asset}/"
      end

      def default_options_for_s3cmd
        "--delete-removed --skip-existing --recursive"
      end

      def custom_config_option
        if File.exists?(custom_config)
          " --config=#{custom_config}"
        end
      end

      def custom_config
        "#{ENV["HOME"]}/.s3cfg-healer"
      end

      def s3_bucket
        Healer::S3_BUCKET
      end
    end

  end
end
