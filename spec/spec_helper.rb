require 'rack/test'
require './app/server'
require './app/services/database_service'

def app
  Server
end

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  include Rack::Test::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before :suite do
    DatabaseService.setup
  end

  config.before :each do
    @conn = DatabaseService.connection
  end

  config.after :each do
    @conn.exec 'DELETE FROM tests'
    @conn.close
  end
end
