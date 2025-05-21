require "ruby_llm/tool"
require "open3"

module Tools
  class RunShellCommand < RubyLLM::Tool
    description "Execute a linux shell command"
    param :command, desc: "The command to execute"

    def execute(command:)
      puts "AI wants to execute the following shell command: '#{command}'"
      print "Do you want to execute it? (y/n) "
      response = gets.chomp
      return { error: "User declined to execute the command" } unless response == "y"

      begin
        stdout_and_stderr, _status = Open3.capture2e(command)
        stdout_and_stderr
      rescue StandardError => e
        { error: e.message }
      end
    end
  end
end
