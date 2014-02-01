require "#{Rails.root}/utility/s3_sync"
require "#{Rails.root}/utility/data_sync"

namespace :sync do

  namespace :images do

    namespace :patients do
      desc "Pull patient images from S3"
      task :pull => :environment do
        with_confirm do
          Healer::Utility::S3Sync.new.pull_patient_photos
        end
      end

      desc "Push patient images to S3"
      task :push => :environment do
        with_confirm(true) do
          Healer::Utility::S3Sync.new.push_patient_photos
        end
      end
    end

    namespace :xrays do
      desc "Pull xray images from S3"
      task :pull => :environment do
        with_confirm do
          Healer::Utility::S3Sync.new.pull_xray_photos
        end
      end

      desc "Push xray images to S3"
      task :push => :environment do
        with_confirm(true) do
          Healer::Utility::S3Sync.new.push_xray_photos
        end
      end
    end

  end

  namespace :data do
    desc "Pull data from Heroku"
    task :pull => :environment do
      with_confirm do
        Healer::Utility::DataSync.new.replace_local_from_heroku
      end
    end

    desc "Back up data to S3"
    task :backup => :environment do
      with_confirm do
        Healer::Utility::DataSync.new.back_up_to_s3
      end
    end
  end

end

def with_confirm(double = false)
  answer = HighLine.new.ask("Are you sure?") { |q| q.default = "n" }
  if %w(y yes).include?(answer.downcase)
    yield unless double
    if double
      answer2 = HighLine.new.ask("Are you REALLY sure?") { |q| q.default = "n" }
      yield if %w(y yes).include?(answer2.downcase)
    end
  end
end