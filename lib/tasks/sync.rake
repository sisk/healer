#encoding: utf-8 

require "#{Rails.root}/utility/s3_sync"
require "#{Rails.root}/utility/data_sync"

namespace :sync do

  namespace :images do

    namespace :patients do
      desc "Pull patient images from S3"
      task :pull => :environment do
        message = "This will replace assets in #{assets_dir}/patients. Are you sure you want to do this?"
        yes_no(:message => message) do
          Healer::Utility::S3Sync.new.pull_patient_photos
        end
      end

      desc "Push patient images to S3"
      task :push => :environment do
        message = "This will replace live assets in S3 with files from #{assets_dir}/patients. Are you sure you want to do this?"
        confirm = "Are you really sure? You can't undo this."
        yes_no(:message => message, :confirm => confirm) do
          Healer::Utility::S3Sync.new.push_patient_photos
        end
      end
    end

    namespace :xrays do
      desc "Pull xray images from S3"
      task :pull => :environment do
        message = "This will replace assets in #{assets_dir}/xrays. Are you sure you want to do this?"
        yes_no(:message => message) do
          Healer::Utility::S3Sync.new.pull_xray_photos
        end
      end

      desc "Push xray images to S3"
      task :push => :environment do
        message = "This will replace live assets in S3 with files from #{assets_dir}/xrays. Are you sure you want to do this?"
        confirm = "Are you really sure? You can't undo this."
        yes_no(:message => message, :confirm => confirm) do
          Healer::Utility::S3Sync.new.push_xray_photos
        end
      end
    end

  end

  namespace :data do
    desc "Pull data from Heroku"
    task :pull do
      message = "This will replace your local database from Heroku. Are you sure you want to do this?"
      yes_no(:message => message) do
        Healer::Utility::DataSync.new(:verbose => true).replace_local_from_heroku
      end
    end

    desc "Push local data to Heroku"
    task :push => :environment do
      message = "This will replace all Heroku production data with your local copy. Are you SURE you want to do this?"
      confirm = "Are you REALLY sure? This is a big decision, and can't be reversed."
      yes_no(:message => message, :confirm => confirm) do
        Healer::Utility::DataSync.new(:verbose => true).push_local_to_heroku
      end
    end

    desc "Back up data to S3"
    task :backup => :environment do
      Healer::Utility::DataSync.new(:verbose => true).back_up_heroku_database_to_s3
    end
  end

end

def yes_no(*args)
  opts = extract_options_from_args(*args)
  answer = HighLine.new.ask(opts[:message]) { |q| q.default = opts[:default_answer] }
  if opts[:yes_input].include?(answer.downcase)
    yield unless opts[:confirm]
    if opts[:confirm]
      second_answer = HighLine.new.ask(opts[:confirm]) { |q| q.default = opts[:default_answer] }
      yield if opts[:yes_input].include?(second_answer.downcase)
    end
  end
end

def extract_options_from_args(*args)
  opts = args.flatten.extract_options!
  {
    :message => opts[:message] || "Are you sure?",
    :confirm => opts[:confirm],
    :yes_input => opts[:yes_input] || %w(y yes),
    :default_answer => opts[:default_answer] || "n"
  }
end

def assets_dir
  Healer::Utility::S3Sync::ASSETS_ROOT
end