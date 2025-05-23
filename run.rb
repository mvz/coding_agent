#!/usr/bin/env ruby
# frozen_string_literal: true

# Load the gems and environment variables from .env file.
Dir.chdir(__dir__) do
  require "bundler/setup"
  require "dotenv/load"
end

require_relative "src/agent"

llm = Langchain::LLM::Anthropic.new(api_key: ENV.fetch("ANTHROPIC_API_KEY"),
                                    default_options: { chat_model: "claude-3-7-sonnet-latest" })

Agent.new(llm).run
