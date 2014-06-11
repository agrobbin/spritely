require 'sass'
require 'spritely/sass_functions'
require 'spritely/sprockets/manifest'

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
end
