$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "spritely/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "spritely"
  s.version     = Spritely::VERSION
  s.authors     = ["Alex Robbin"]
  s.email       = ["alex@robbinsweb.biz"]
  s.homepage    = "https://github.com/agrobbin/spritely"
  s.license     = "MIT"
  s.summary     = "Hooks into the Sprockets asset packaging system to allow you to easily generate sprite maps"

  s.files = Dir["lib/**/*"]
  s.test_files = Dir["spec/**/*"]

  s.required_ruby_version = '>= 2.2.0'

  s.add_dependency 'chunky_png', '~> 1.3'
  s.add_dependency 'sass', '~> 3.3'
  s.add_dependency 'sprockets', '~> 3.0'

  s.add_development_dependency 'activesupport'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'sprockets-rails'
  s.add_development_dependency 'railties'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '>= 3.0'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'appraisal'
end
