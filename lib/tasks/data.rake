require "#{Rails.root}/utility/s3_sync"

namespace :data do

  namespace :patients do

    desc "Pull photos from S3"
    task :pull_photos => :environment do
      answer = HighLine.new.ask("Are you sure?") { |q| q.default = "n" }
      if %w(y yes).include?(answer.downcase)
        Healer::Utility::S3Sync.new.pull_patient_photos
      end
    end

    desc "Push photos to S3"
    task :push_photos => :environment do
      answer = HighLine.new.ask("Are you sure?") { |q| q.default = "n" }
      if %w(y yes).include?(answer.downcase)
        answer2 = HighLine.new.ask("Are you REALLY sure you want to replace S3 patient photos with your local version?") { |q| q.default = "n" }
        if %w(y yes).include?(answer2.downcase)
          Healer::Utility::S3Sync.new.push_patient_photos
        end
      end
    end

  end

  namespace :xrays do

    desc "Pull photos from S3"
    task :pull_photos => :environment do
      answer = HighLine.new.ask("Are you sure?") { |q| q.default = "n" }
      if %w(y yes).include?(answer.downcase)
        Healer::Utility::S3Sync.new.pull_xray_photos
      end
    end

    desc "Push photos to S3"
    task :push_photos => :environment do
      answer = HighLine.new.ask("Are you sure?") { |q| q.default = "n" }
      if %w(y yes).include?(answer.downcase)
        answer2 = HighLine.new.ask("Are you REALLY sure you want to replace S3 xray photos with your local version?") { |q| q.default = "n" }
        if %w(y yes).include?(answer2.downcase)
          Healer::Utility::S3Sync.new.push_xray_photos
        end
      end
    end

  end

end