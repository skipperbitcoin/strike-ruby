# Rakefile
require "bundler/gem_tasks"
require "rake/testtask"
require "rubocop/rake_task"
require "simplecov"

# Default task runs tests and code quality checks
task default: [:test, :rubocop]

# Test configuration
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
  t.warning = false
end

# Code quality checks
RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = ["--display-cop-names", "--extra-details"]
end

# Documentation generation (optional but recommended)
desc "Generate documentation"
task :docs do
  sh "yard doc --output-dir=docs"
end

# Coverage reporting
begin
  require "simplecov"
  SimpleCov.start do
    enable_coverage :branch
    add_filter "/test/"
    minimum_coverage line: 90, branch: 85
  end
rescue LoadError
  # SimpleCov not available, skip
end

# Release preparation task
desc "Prepare for release"
task :prepare do
  # Verify tests pass
  Rake::Task["test"].invoke
  
  # Verify code quality
  Rake::Task["rubocop"].invoke
  
  # Verify version bump
  version = File.read("lib/strike/version.rb")[/VERSION = "(.*?)"/, 1]
  puts "Releasing version #{version}"
  
  # Update CHANGELOG
  sh "bundle exec auto-changelog -p -u -t '## [unreleased] -> ## [#{version}] - %{date}'"
end

# Release task (handled by bundler/gem_tasks)
# Use `rake release` to build and push to RubyGems