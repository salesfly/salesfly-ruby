require File.expand_path("lib/salesfly/version", File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name = "salesfly"
  s.version = Salesfly::VERSION
  s.authors = ["Salesfly"]
  s.email = ["hello@salesfly.com"]
  s.license = "MIT"
  s.homepage = "https://github.com/salesfly/salesfly-ruby"
  s.description = "Ruby client for Salesfly API"
  s.summary = "This is the Ruby client library for the Salesfly API. To use it you will need an Salesfly account. Sign up for free at https://salesfly.com"
  s.platform = Gem::Platform::RUBY
  s.files = Dir.glob("{lib,test}/**/*") + %w(LICENSE README.md salesfly.gemspec)
  s.required_ruby_version = ">= 2.2.0"
  s.add_dependency("rest-client", "~> 2.1.0")
  s.add_dependency("json-schema", "~> 2.8.0")
  s.add_development_dependency("rake", "~> 12.0")
  s.add_development_dependency("minitest", "~> 5.0")
  s.add_development_dependency("simplecov", "~> 0.16")
  s.add_development_dependency("codecov", "~> 0.1.10")
  s.require_path = "lib"
end
