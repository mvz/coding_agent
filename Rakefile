# frozen_string_literal: true

require "rake"
require "rake/testtask"

desc "Run all tests"
Rake::TestTask.new(:test) do |t|
  t.libs << "lib"
  t.test_files = FileList["test/*_test.rb"]
  t.verbose = true
end

task default: :test
