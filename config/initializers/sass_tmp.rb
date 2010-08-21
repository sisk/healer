# http://mentalized.net/journal/2010/04/06/heroku_rails_3_and_sass/
require "fileutils"
FileUtils.mkdir_p(Rails.root.join("tmp", "stylesheets", "compiled"))

# ActionController::Dispatcher.middleware.use(Rack::Static, :root => "tmp/", :urls => ["/stylesheets/compiled"])