require 'rspec'
require 'pry-byebug'
require 'spritely'

Dir["./spec/support/**/*.rb"].sort.each {|f| require f}
