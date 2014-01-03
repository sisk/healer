namespace :migrations do

  task :body_parts => :environment do
    require "body_part_migrator"
    BodyPartMigrator.new.perform
  end

end