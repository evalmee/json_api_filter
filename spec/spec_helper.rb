require "bundler/setup"
require "json_api_filter"
ENV["RAILS_ENV"] ||= "test"
ENV["RAILS_ROOT"] ||= File.expand_path("dummy", __dir__)
require File.expand_path("dummy/config/environment.rb", __dir__)
require "rspec/rails"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
