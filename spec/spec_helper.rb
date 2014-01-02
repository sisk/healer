# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require "remarkable/active_record"
require "factory_girl_rails"

require "devise/test_helpers"
include Devise::TestHelpers

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/shared/**/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec

  config.include Devise::TestHelpers, :type => :controller
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.extend ControllerMacros, :type => :controller

  config.use_transactional_fixtures = true
  config.global_fixtures = :all
  config.include FactoryGirl::Syntax::Methods
end

def stub_user
  allow_message_expectations_on_nil
  user = double("user", :language => "en")
  request.env["warden"].stub :authenticate! => user
  controller.stub :current_user => user
end

def stub_no_user
  allow_message_expectations_on_nil
  request.env["warden"].stub(:authenticate!).
  and_throw(:warden, {:scope => :user})
end