# frozen_string_literal: true

require "ruby_llm"
require_relative "tools/read_file"
require_relative "tools/list_files"
require_relative "tools/edit_file"
require_relative "tools/run_shell_command"

class Agent
  def initialize
    @chat = RubyLLM.chat
    @chat.with_instructions "You are a helpful coding assistant with file system access."
    @chat.on_tool_call(&method(:tool_execution_callback))
    @chat.on_end_message(&method(:add_message_callback))
    @chat.with_tools(*standard_tools)
  end

  def run
    instruct_user
    loop do
      user_input = read_user_input or break
      evaluate_input(user_input)
      print_result
    end
  rescue RubyLLM::BadRequestError => e
    puts e.message
    exit
  end

  private

  def add_message_callback(message)
    case message.role
    when :user, :tool
      # skip
    when :assistant
      puts message.content if message.tool_calls&.any?
    else
      raise NotImplementedError
    end
  end

  def tool_execution_callback(tool_call)
    puts "** executing #{tool_call.name} with #{tool_call.arguments.inspect}"
  end

  def standard_tools
    [
      Tools::ReadFile,
      Tools::ListFiles,
      Tools::EditFile,
      Tools::RunShellCommand
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
    @response = @chat.ask user_input
  end

  def print_result
    puts @response.content
  end
end
