require 'rspec'
require 'rspec/its'
require 'generator_spec/generator_example_group'
require 'spritely'

require 'pry-byebug'

Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include "Sprockets#{Spritely.sprockets_version}SassFunctionsHelpers".constantize, :sass_functions

  config.include RailsAppHelpers, :integration
  config.include GeneratorSpec::GeneratorExampleGroup, :generator
  config.around(:each, :integration) { |example| within_rails_app(&example) }
end
