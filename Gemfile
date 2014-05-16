source "http://rubygems.org"
ruby "1.9.3"

gem "rails", "~> 3.2.14"

gem "aws-s3", "~> 0.6.3"
gem "aws-sdk", "~> 1.33.0" # required for paperclip to upload to s3
# gem "sqlite3-ruby", :require => "sqlite3"
gem "mysql2", "~> 0.3.11"
gem "pg"
gem "draper"
gem "haml"
gem "devise", "1.5.3"
gem "declarative_authorization", "0.5.3"
gem "formtastic", "~> 2.3.0.rc2" # TODO deprecate
gem "simple_form", "~> 2.1"
gem "hashie", "~> 2.0.5"
gem "carmen", "~> 1.0.0"
gem "paperclip"
gem "test-unit" # TODO deprecate
gem "inherited_resources", "~> 1.3.1" # TODO deprecate
gem "will_paginate", "~> 3.0.3"
gem "dotiw", "1.1.1"
gem "jquery-rails", "~> 3.1.0"
gem "jquery-ui-rails", "~> 4.1.1"
gem "fancybox2-rails", "~> 0.2.6"
gem "exception_notification"
gem "friendly_id"
gem "rake"
gem "remotipart", "~> 1.2"
# gem "google_drive" # enable for PatientBulkInput
gem "highline"
gem "puma"

group :development, :test do
  gem "pry"
  gem "test_notifier", :require => false
  gem "rspec-rails", ">= 2.0.0", :require => false
  gem "factory_girl_rails", :require => false
  gem "letter_opener", :require => false
  gem "hamls_comment", :require => false
  gem "taps", :require => false # has an sqlite dependency, which heroku hates
  gem "sqlite3", :require => false
end

group :assets do
  gem 'sass-rails', "~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', '>=1.0.3'
  gem "compass-rails"
  gem "foundation-rails", "5.2.2.0"
end

# Use thin as the web server
gem "thin"