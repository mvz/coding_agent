require "langchain"
require "open3"

module Tools
  class RunShellCommand
    extend Langchain::ToolDefinition

    define_function :execute, description: "Execute a Linux shell command" do
      property :command, type: "string", description: "The shell command to execute", required: true
    end

    def execute(command:)
      puts "AI wants to execute the following shell command: '#{command}'"
      print "Do you want to execute it? (y/n) "
      response = gets.chomp
      return { error: "User declined to execute the command" } unless response.downcase == "y"

      begin
        stdout_and_stderr, _status = Open3.capture2e(command)
        stdout_and_stderr
      rescue StandardError => e
        { error: e.message }
      end
    end
  end
end
