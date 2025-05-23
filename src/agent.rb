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
    instruct_user
    loop do
      user_input = read_user_input or break
      evaluate_input(user_input)
      print_result
    end
  rescue StandardError => e
    puts "Error: #{e.message}"
    exit
  end

  private

  def instruct_user
    puts "Chat with the agent. Type 'exit' to ... well, exit"
  end

  def read_user_input
    print "> "
    user_input = gets.chomp
    return false if user_input.strip.downcase == "exit"

    user_input
  end

  def evaluate_input(user_input)
    @assistant.add_message_and_run!(content: user_input)
  end

  def print_result
    puts @assistant.messages.last.content
  end
end
