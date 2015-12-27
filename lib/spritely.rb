require 'sass'
require 'sprockets/rails/version'
require 'sprockets/version'
require 'spritely/sass_functions'
require 'spritely/sprockets/manifest'
require 'spritely/adapters/sprockets_2'
require 'spritely/adapters/sprockets_3'

module Spritely
  def self.environment
    ::Rails.application.assets
  end

  def self.directory
    ::Rails.root.join(relative_folder_path)
  end

  def self.relative_folder_path
    Pathname.new(File.join('app', 'assets', 'images', 'sprites'))
  end

  def self.sprockets_version
    Gem::Version.new(Sprockets::VERSION).segments.first
  end

  def self.sprockets_adapter
    Adapters.const_get("Sprockets#{sprockets_version}").new
  end
end
