# frozen_string_literal: true

require "langchain"

module Tools
  class EditFile
    extend Langchain::ToolDefinition
    description = <<~DESCRIPTION
      Make edits to a text file.

      Replaces 'old_str' with 'new_str' in the given file.
      'old_str' and 'new_str' MUST be different from each other.

      If the file specified with path doesn't exist, it will be created.
    DESCRIPTION

    define_function :execute, description: description do
      property :path, type: "string", description: "The path to the file", required: true
      property :old_str, type: "string",
                         description: "Text to search for - must match exactly and must only have one match exactly",
                         required: true
      property :new_str, type: "string", description: "Text to replace old_str with", required: true
    end

    def execute(path:, old_str: "", new_str: "")
      content = File.exist?(path) ? File.read(path) : ""
      new_content = content.sub(old_str, new_str)
      File.write(path, new_content)

      { success: true, message: "Successfully updated file: #{path}" }
    rescue StandardError => e
      { error: e.message }
    end
  end
end
