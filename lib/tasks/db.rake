require 'active_record'
require 'active_record/fixtures'
namespace :db do

  desc 'Load up the base data'
  task :bootstrap => [ 'db:migrate' ] do
    Rake::Task["db:seed"].invoke
  end
  
  desc "Load base data without migrations (straight db/data fixture load)"
  task :seed => :environment do
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[RAILS_ENV])
  
    base_dir = ENV['FIXTURES_PATH'] ? File.join(Rails.root, ENV['FIXTURES_PATH']) : File.join(Rails.root, 'db', 'data')
    fixture_dir = ENV['FIXTURES_DIR'] ? File.join(base_dir, ENV['FIXTURES_DIR']) : base_dir
    (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/).map {|f| File.join(fixture_dir, f) } : Dir.glob(File.join(fixture_dir, '*.{yml,csv}'))).each do |fixture_file|
      Fixtures.create_fixtures(File.dirname(fixture_file), File.basename(fixture_file, '.*'))
    end
  end
  
end
