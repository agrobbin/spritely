require 'rspec'
require 'rspec/its'
require 'spritely'

require 'pry-byebug'

Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include RailsAppHelpers, :integration
  config.around(:each, :integration) { |example| within_rails_app(&example) }
end
