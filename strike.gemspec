lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "strike/version"

Gem::Specification.new do |spec|
  spec.name          = "strike"
  spec.version       = Strike::VERSION
  spec.authors       = ["Skipper Bitcoin"]
  spec.email         = ["btcsailor@protonmail.com"]

  spec.summary       = "Unofficial Ruby client for the Strike API"
  spec.description   = "A Ruby interface to the Strike API for Bitcoin Lightning payments"
  spec.homepage      = "https://github.com/skipperbitcoin/strike-ruby"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/skipperbitcoin/strike-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/skipperbitcoin/strike-ruby/releases"

  # Specify which files to include in the gem
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Dependencies
  spec.add_dependency "faraday", "~> 2.7"
  spec.add_dependency "faraday-follow_redirects", "~> 0.3"
  spec.add_dependency "activesupport", ">= 5.2" # For Rails compatibility

  # Development dependencies
  spec.add_development_dependency "bundler", ">= 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "webmock", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.14"
end