# frozen_string_literal: true

require "bundler/setup"
Bundler.setup

require "simplecov"
SimpleCov.start

RSpec.configure do |config|
  config.expect_with :rspec do |expect|
    expect.syntax = :expect
    expect.max_formatted_output_length = 1024
  end
end
