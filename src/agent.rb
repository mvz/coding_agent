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
      tools: standard_tools,
      add_message_callback: method(:add_message_callback).to_proc,
      tool_execution_callback: method(:tool_execution_callback).to_proc
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

  def add_message_callback(message)
    case message.standard_role
    when :user, :tool
      # skip
    when :llm
      puts message.content if message.tool_calls.any?
    else
      raise NotImplementedError
    end
  end

  def tool_execution_callback(_tool_call_id, tool_name, method_name, tool_arguments)
    puts "** executing #{tool_name}##{method_name} with #{tool_arguments.inspect}"
  end

  def standard_tools
    [
      Tools::ReadFile.new,
      Tools::ListFiles.new,
      Tools::EditFile.new,
      Tools::RunShellCommand.new
    ]
  end

  def instruct_user
    puts "Chat with the agent. Type 'exit' to ... well, exit"
  end

  def read_user_input
    print "> "
    user_input = gets&.chomp or return false
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
