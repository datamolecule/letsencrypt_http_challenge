# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

# The .well-known/acme-challenge route will not be defined unless this environment variable is defined
ENV['LE_HTTP_CHALLENGE_RESPONSE'] = '58u1GLEGwgSbK-3LnTYUDwZySN3FmTxE4CuqAf8IpAU.VDnmZ7G7W4pPpHL_rTLA9SUPSN0qTwe876q2C2gpLLs'


require File.expand_path("../../test/dummy/config/environment.rb",  __FILE__)
# ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../test/dummy/db/migrate", __FILE__)]
# ActiveRecord::Migrator.migrations_paths << File.expand_path('../../db/migrate', __FILE__)
require "rails/test_help"

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
# if ActiveSupport::TestCase.respond_to?(:fixture_path=)
#   ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
#   ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
#   ActiveSupport::TestCase.fixtures :all
# end
