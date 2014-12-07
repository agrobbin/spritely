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
  s.summary     = "Hooks into the Rails asset pipeline to allow you to easily generate sprite maps"

  s.files = Dir["lib/**/*"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'chunky_png', '~> 1.3'
  s.add_dependency 'railties', '>= 4.0.0', '< 5.0'
  s.add_dependency 'sass', '~> 3.1'
  s.add_dependency 'sprockets-rails', '>= 2.0'

  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '>= 3.0'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'generator_spec'
end
