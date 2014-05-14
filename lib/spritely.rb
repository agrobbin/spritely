require 'sass'
require 'spritely/sass_functions'

raise LoadError, "Spritely cannot be used in conjunction with Compass. Hope you choose Spritely!" if defined?(::Compass)

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
