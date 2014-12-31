$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "houston/reports/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "houston-reports"
  s.version     = Houston::Reports::VERSION
  s.authors     = ["Bob Lail"]
  s.email       = ["bob.lail@cph.org"]
  s.homepage    = "https://github.com/concordia-publishing-house/houston-reports"
  s.summary     = "Email Reports from Houston"
  s.description = "Email Reports from Houston"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
end
