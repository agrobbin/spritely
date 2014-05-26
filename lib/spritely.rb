require 'sass'
require 'spritely/sass_functions'
require 'spritely/sprockets/manifest'

module Spritely
  def self.environment
    ::Rails.application.assets
  end

  def self.directory
    ::Rails.root.join('app', 'assets', 'images', 'sprites')
  end
end
