$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "spritely/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "spritely"
  s.version     = Spritely::VERSION
  s.authors     = ["Alex Robbin"]
  s.email       = ["alex@robbinsweb.biz"]
  s.homepage    = "http://www.robbinsweb.biz"
  s.license     = "MIT"
  s.summary     = "Hooks into the Rails asset pipeline to allow you to easily generate sprite maps"

  s.files = Dir["lib/**/*"]
  s.test_files = Dir["spec/**/*"]

  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'rspec'
end
