require 'sass'
require 'sprockets/rails/version'
require 'sprockets/railtie'
require 'spritely/sass_functions'
require 'spritely/sprockets/manifest'

module Spritely
  def self.environment
    if sprockets_rails_version == 3
      ::Rails.application.assets || ::Sprockets::Railtie.build_environment(::Rails.application)
    else
      ::Rails.application.assets
    end
  end

  def self.directory
    ::Rails.root.join(relative_folder_path)
  end

  def self.relative_folder_path
    Pathname.new(File.join('app', 'assets', 'images', 'sprites'))
  end

  def self.sprockets_rails_version
    Gem::Version.new(::Sprockets::Rails::VERSION).segments.first
  end
end
