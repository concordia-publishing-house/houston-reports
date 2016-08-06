$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "houston/reports/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "houston-reports"
  spec.version     = Houston::Reports::VERSION
  spec.authors     = ["Bob Lail"]
  spec.email       = ["bob.lail@cph.org"]

  spec.summary     = "Email Reports from Houston"
  spec.description = "Email Reports from Houston"
  spec.homepage    = "https://github.com/cph/houston-reports"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]
  spec.test_files = Dir["test/**/*"]

  spec.add_development_dependency "bundler", "~> 1.10.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "houston-core", ">= 0.5.3"
end
