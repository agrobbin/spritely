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

  def self.modification_time(filename)
    File.mtime(filename).to_i
  end
end
