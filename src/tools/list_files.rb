# frozen_string_literal: true

require "langchain"

module Tools
  class ListFiles
    extend Langchain::ToolDefinition

    define_function :execute,
                    description: "List files and directories at a given path. If no path is provided, lists files in the current directory." do
      property :path, type: "string",
                      description: "Optional relative path to list files from. Defaults to current directory if not provided.", required: false
    end

    def execute(path: "")
      Dir.glob(File.join(path, "*")).map do |filename|
        File.directory?(filename) ? "#{filename}/" : filename
      end
    rescue StandardError => e
      { error: e.message }
    end
  end
end
