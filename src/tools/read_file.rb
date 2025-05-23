# frozen_string_literal: true

require "langchain"

module Tools
  class ReadFile
    extend Langchain::ToolDefinition

    define_function :execute,
                    description: "Read the contents of a given relative file path. Use this when you want to see what's inside a file. Do not use this with directory names." do
      property :path, type: "string", description: "The relative path of a file in the working directory.",
                      required: true
    end

    def execute(path:)
      raise "Provided path is a directory, not a file" if File.directory?(path)

      File.read(path)
    rescue StandardError => e
      { error: e.message }
    end
  end
end
