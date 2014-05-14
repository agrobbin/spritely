require 'rspec'
require 'spritely'

require 'pry-byebug'

Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.include RailsAppHelpers, :integration
  config.around(:each, :integration) { |example| within_rails_app(&example) }
end
