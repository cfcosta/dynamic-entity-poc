# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

module Fixture
  extend self

  def load(filename)
    file = File.expand_path("./fixtures/#{filename}.json", __dir__)
    MultiJson.load(File.read(file), symbolize_keys: true)
  end

  def load_schema(file)
    file = File.expand_path("./fixtures/#{filename}.schema.json", __dir__)
    MultiJson.load(File.read(file), symbolize_keys: true)
  end
end

ActiveRecord::Migration.maintain_test_schema!

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include JSON::SchemaMatchers
  Dir['**/*.schema.json'].each do |file|
    fixture_name = File.basename(file).split('.')[0..-3].join(".")
    config.json_schemas[fixture_name.to_sym] = file
  end
end
