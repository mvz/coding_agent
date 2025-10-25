#!/usr/bin/env ruby
# frozen_string_literal: true

# Load the gems and environment variables from .env file.
Dir.chdir(__dir__) do
  require "bundler/setup"
  require "dotenv/load"
end

require_relative "lib/agent"

RubyLLM.configure do |config|
  config.anthropic_api_key = ENV.fetch("ANTHROPIC_API_KEY", nil)
  config.default_model = "claude-3-7-sonnet"
  config.log_file = "ruby_llm.log"
  config.log_level = :info
end

Agent.new.run
