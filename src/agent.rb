# frozen_string_literal: true

require "langchain"
require_relative "tools/read_file"
require_relative "tools/list_files"
require_relative "tools/edit_file"
require_relative "tools/run_shell_command"

class Agent
  def initialize(llm)
    @assistant = Langchain::Assistant.new(
      llm: llm,
      instructions: "You are a helpful coding assistant with file system access.",
      tools: [
        Tools::ReadFile.new,
        Tools::ListFiles.new,
        Tools::EditFile.new,
        Tools::RunShellCommand.new
      ]
    )
  end

  def run
    puts "Chat with the agent. Type 'exit' to ... well, exit"
    loop do
      print "> "
      user_input = gets.chomp
      break if user_input.strip.downcase == "exit"

      begin
        @assistant.add_message_and_run(content: user_input)
        puts @assistant.messages.last.content
      rescue StandardError => e
        puts "Error: #{e.message}"
        exit
      end
    end
  end
end
